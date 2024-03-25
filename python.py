import json
from flask import Flask, jsonify, render_template, redirect, url_for, request, flash
from flask_sqlalchemy import SQLAlchemy 
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from sqlalchemy import extract, or_
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename
from datetime import datetime
from fastapi.encoders import jsonable_encoder
from flask_socketio import SocketIO, join_room, leave_room, send


app = Flask(__name__)
socketio = SocketIO(app)
socketio.init_app(app, cors_allowed_origins="*")
app.config['SECRET_KEY'] = 'your-secret-key'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite'

db = SQLAlchemy(app)
login_manager = LoginManager()
login_manager.init_app(app)

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nickname = db.Column(db.String(100), unique=True)
    password_hash = db.Column(db.String(100))
    dob = db.Column(db.Date)
    description = db.Column(db.Text)
    age = db.Column(db.Integer)
    #photo blob format
    photo = db.Column(db.String(1000))
    rating = db.Column(db.Integer, default=0)
    city = db.Column(db.String(100))

   
        

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)




class Like(db.Model):
    __tablename__ = 'likes'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    liked_user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    message = db.Column(db.Text, nullable=True)
    
    # Relationships
    user = db.relationship('User', foreign_keys=[user_id])
    liked_user = db.relationship('User', foreign_keys=[liked_user_id])



    @classmethod
    def can_message_each_other(cls, user1_id, user2_id):
        # Check if both users liked each other
        like1 = cls.query.filter_by(user_id=user1_id, liked_user_id=user2_id).first()
        like2 = cls.query.filter_by(user_id=user2_id, liked_user_id=user1_id).first()
        return bool(like1) and bool(like2)


class Message(db.Model):
    __tablename__ = 'messages'

    id = db.Column(db.Integer, primary_key=True)
    sender_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    recipient_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    body = db.Column(db.Text)
    timestamp = db.Column(db.DateTime, index=True, default=datetime.utcnow)

    # Relationships
    sender = db.relationship('User', foreign_keys=[sender_id], backref='sent_messages')
    recipient = db.relationship('User', foreign_keys=[recipient_id], backref='received_messages')





@app.route('/send_message', methods=['POST'])
@login_required
def send_message():
    recipient_id = request.form.get('user_id')
    message_body = request.form.get('message_body')

    if recipient_id and message_body:
        message = Message(sender_id=current_user.id, recipient_id=recipient_id,
                          body=message_body, timestamp=datetime.utcnow())
        db.session.add(message)
        db.session.commit()
        flash('Your message has been sent!', 'success')
    else:
        flash('Message sending failed. Please check the recipient and the message body.', 'danger')
    
    return redirect(url_for('messages'))



    



@app.route('/api/like', methods=['POST'])
@login_required
def handle_like():
    try:
        if request.method == 'POST':
            data = request.form
            message = data.get('message')
            name = data.get('name')
            photo = data.get('photo')
            try:
                liked_user_id = int(photo.split('\\')[-1].split('.')[0])
            except:
                liked_user_id = photo.split('/')[-1].split('.')[0]     
            existing_like = Like.query.filter_by(
                user_id=current_user.id,
                liked_user_id=liked_user_id
            ).first()
        if not photo:
            return jsonify({'message': 'Liked user ID is missing.'}), 400
        elif liked_user_id == current_user.id:
            return jsonify({'message': 'You cannot like yourself.'}), 200
        
        elif existing_like:
            return jsonify({'message': 'You have already liked this user.'}), 200

        else:
            like = Like(user_id=current_user.id, liked_user_id=liked_user_id, message=message)

            if name:
                admin_mess = f'Для тебя новая заявка от юзера! Вот сообщение для тебя: {message}. \
                    Решай, добавить его в друзья или нет: <button class="btn btn-primary accept">Добавить в друзья</button>\
                    <button class="btn btn-danger disaccept">Отклонить</button>\
                    \n Имя: {name} <img src="../static/img/{current_user.id}.jpg" id="PhotoPathc"> \
                    <input type="hidden" id="user_id" value="{liked_user_id}">\
                    <input type="hidden" id="PhotoPath" value="../static/img/{current_user.id}.jpg">'
                add_mess = Message(sender_id=1, recipient_id=liked_user_id, body=admin_mess)
                db.session.add(add_mess)
                liked_user = User.query.get(liked_user_id)
                liked_user.rating += 1

            db.session.add(like)
            db.session.commit()
        # send_friend_request_notification(current_user.id, liked_user_id, message)
            return jsonify({'message': 'Like has been registered.'}), 200
    except Exception as ex:
        print(ex)



@login_manager.user_loader
def load_user(user_id):
    return db.session.get(User, int(user_id))

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/profile/<int:user_id>')
@login_required
def profile(user_id):
    user = User.query.get(user_id)
    return render_template('profile.html', user=user)

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        nickname = request.form.get('nickname')
        password = request.form.get('password')
        
        #today datetime from datetime lib
        dob = datetime.now().date()
        
        
        user = User(nickname=nickname, dob=dob)
        user.set_password(password)
        db.session.add(user)
        db.session.commit()

        return redirect(url_for('login'))
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        nickname = request.form.get('nickname')
        password = request.form.get('password')
        
        remember = True if request.form.get('remember') else False

        user = User.query.filter_by(nickname=nickname).first()
        if user and user.check_password(password):
            login_user(user, remember=remember)
            return redirect(url_for('profile', user_id=user.id))

        flash('Invalid nickname or password')

    return render_template('login.html')

@app.route('/profiles')
@login_required
def profiles():
    # Assuming there is a 'like' functionality implemented
    # Sort profiles by rating (likes) or just all profiles
    sort_by = request.args.get('sort', 'all')
    if sort_by == 'rating':
        all_profiles = User.query.order_by(User.rating.desc()).all()
    else:
        all_profiles = User.query.all()

    return render_template('profiles.html', profiles=all_profiles)

# @app.route('/message')
# @login_required
# def message():
#     # Assuming there is a Message model and messages are stored in the database
#     user_messages = Message.query.filter_by(user_id=current_user.id).all()
#     return render_template('message.html', messages=user_messages)


#update photo profile blob
@app.route('/update_photo', methods=['POST'])
def update_photo():
    try:

        if request.method == 'POST':
            import os
            dir_path = os.path.dirname(os.path.realpath(__file__))
            f = request.files['avatar']
            filename = '../static/img/' + str(current_user.id) + '.jpg'
            # Save the file to disk
            
            f.save(dir_path +'/static/img/' + str(current_user.id) + '.jpg')
            user = User.query.get(current_user.id)
            user.photo = filename
            db.session.commit()
            return redirect(url_for('profile', user_id=current_user.id))
    except Exception as ex:
        return str(ex)


@app.route('/clear_dialog', methods=['POST'])
def clear_dialog():
    if request.method == 'POST':
        recipient_id = request.form['recipient_id']
        user_id = request.form['user_id']
        Message.query.filter_by(sender_id=recipient_id, recipient_id=user_id).delete()
        Message.query.filter_by(sender_id=user_id, recipient_id=recipient_id).delete()
        db.session.commit()
        return redirect(url_for('messages'))
    

#profile update(desctiption)
@app.route('/update_description', methods=['POST'])
def update_description():
    if request.method == 'POST':
        user = User.query.get(current_user.id)
        if request.form['description'] == '':
            pass
        else:
            user.city = request.form['city']
        if request.form['city'] == '':
            pass
        else:
            user.description = request.form['description']
        
        user.dob = datetime.strptime(request.form['dob'], '%Y-%m-%d').date()
        db.session.commit()
        return redirect(url_for('profile', user_id=current_user.id))

#surveys
@app.route('/surveys')
def surveys():
    return render_template('surveys.html')


#api surveys - передача всех анкет 
@app.route('/api/surveys')
def get_surveys():
    # Assuming qryresult is your SQLAlchemy query result
    items = User.query.all()
    data = jsonable_encoder(items)
    return jsonify(data)

#апи запрос для сортировки по рейтингу, дате и городу

@app.route('/api/sorted_surveys')
def sorted_surveys():
    sort_by = request.args.get('sort_by', None)

    if sort_by == 'rating':
        sorted_items = db.session.query(User).order_by(User.rating.desc()).all()
    elif sort_by == 'birthdate':
        year_user = current_user.dob.year
        sorted_items = User.query.filter((extract('year', User.dob) == year_user)  | (extract('year', User.dob) == year_user-1)| (extract('year', User.dob) == year_user+1)).all()
        
        
    elif sort_by == 'city':
        sorted_items = User.query.filter_by(city=current_user.city).all()
    else:
        sorted_items = User.query.all()

    data = jsonable_encoder(sorted_items)
    return jsonify(data)
    


@app.route('/messages/<int:user_id>')
@login_required
def get_messages(user_id):
    messages = Message.query.filter(
        (Message.sender_id == user_id) & (Message.recipient_id == current_user.id)
    ).all()
    or_messages = Message.query.filter(
        (Message.sender_id == current_user.id) & (Message.recipient_id == user_id)
    ).all()
    messages.extend(or_messages)
    
    data = jsonable_encoder(messages)
    return jsonify(data)




@socketio.on('message')
@login_required
def handleMessage(data):
    send(data,broadcast=True)

    
        
    try:
        recipient_id = data.get('recipient_id')
        message_body = data.get('message_body')

        if recipient_id and message_body:
                if 'command' in data:
                    if data['command'] == 'block':
                        recipient_id = data['recipient_id']
                        sender_id = data['sender_id']
                        like = db.session.query(Like).filter(Like.user_id  == sender_id, Like.liked_user_id==recipient_id).first()
                        
                        if like:
                            db.session.delete(like)
                            db.session.commit()
                        else:
                            flash('You have not liked this user.', 'danger')

                message = Message(sender_id=current_user.id, recipient_id=recipient_id,
                                body=message_body, timestamp=datetime.utcnow())
                db.session.add(message)
                db.session.commit()
                flash('Your message has been sent!', 'success')
        else:
                flash('Message sending failed. Please check the recipient and the message body.', 'danger')
    except Exception as ex:
        print(ex)


@app.route('/messages')
@login_required
def messages():
    user_id = current_user.id
    # Get the list of user_ids who mutually liked each other
    
    #Проверка взаимных лайков с бд Like(нужно взять все идшники лайкнутых и проверить, у кого лайкнут текущий юзер. Затем проверить кого лайкнул текущий юзер. И если оба юзера лайкнули в сумме - то добавлять в чаты)
    mutual_likes = db.session.query(Like).filter(Like.user_id == user_id).all() #get own likes

    mutual_likes_re = []
    for mutual_like in mutual_likes: # all your likes
        liked_users  = db.session.query(Like).filter(Like.user_id == mutual_like.liked_user_id).all()
        if liked_users:
            for liked_user in liked_users:
                if liked_user.liked_user_id == current_user.id:
                    mutual_likes_re.append(mutual_like)
        else:
            pass
    mutual_likes_ids = [like.liked_user_id for like in mutual_likes_re]


    

    #mutual_likes_ids = [id[0] for id in mutual_likes_ids]

    # Always include chat with user_id 1
    mutual_likes_ids.append(1)

    # Remove duplicates just in case
    mutual_likes_ids = list(set(mutual_likes_ids))

    # # Get chats for mutual likes
    # chats = []
    # Fetch user names and photo paths for all user ids in mutual_likes_ids
    chats = []
    for user_id in mutual_likes_ids:
        user = User.query.get(user_id)
        if user:
            chats.append({
                'id': user_id,
                'name': user.nickname,
                'photo_path': user.photo
            })
    return render_template('messages.html', chats=chats)



# if __name__ == '__main__':
    
#     with app.app_context():
#         db.create_all()
#         socketio.run(app,debug=True, allow_unsafe_werkzeug=True, host='0.0.0.0')
