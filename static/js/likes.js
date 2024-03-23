$(document).ready(function() {
  $.ajax({
    url: '/api/surveys',
    type: 'GET',
    dataType: 'json',
    success: function(profiles) {
      const profilesGrid = $('.profilesGrid');
      profilesGrid.empty();
      profiles.forEach(profile => {
        const profileCard = `
          <div class="mb-3 col-12 col-sm-6 col-md-4 col-lg-3 text-center profile-card">
            <div class="card h-100" style="width: 100%; height: 100%;">
              <img src="${profile.photo}" class="card-img-top" alt="${profile.nickname}" style="object-fit: cover; height: 260px;">
              <div class="card-body">
                <h5 class="card-title">${profile.nickname}</h5>
                <p class="card-text">${profile.description}</p>
              </div>
              <div class="card-footer">
                <small class="text-muted">${profile.city}, ${new Date(profile.dob).toLocaleDateString()}</small>
              </div>
            </div>
          </div>
        `;
        profilesGrid.append(profileCard);
      });
    },
    error: function(error) {
      console.error('Error fetching profiles:', error);
    }
  });

  var modal = $('#myModal');

  $(document).on('click', '.myBtn', function() {
    modal.show();
  });

  var span = $('.close');
  span.on('click', function() {
    modal.hide();
  });

  $(window).on('click', function(event) {
    if ($(event.target).is(modal)) {
      modal.hide();
    }
  });

  $('#sendLike').unbind('click').on('click', function() {
    const comment = $('#likeComment').val();
    $.ajax({
      url: '/api/send_like',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({ comment: comment }),
      success: function() {
        modal.hide();
      },
      error: function() {
      }
    });
  });
});


// Function to handle sorting profiles
$(document).ready(function() {
  $('#sort-selector').change(function() {
    var sortBy = $(this).val();
    $.ajax({
      url: '/api/sorted_surveys',
      type: 'GET',
      data: { sort_by: sortBy },
      dataType: 'json',
      success: function(data) {
        // Code to handle the sorted data
        // Clear all previous profiles and insert new ones
        const profilesGrid = $('.profilesGrid');
        profilesGrid.empty();
        data.forEach(profile => {
          const profileCard = `
            <div class="mb-3 col-12 col-sm-6 col-md-4 col-lg-3 text-center profile-card">
              <div class="card h-100" style="width: 100%; height: 100%;">
                <img src="${profile.photo}" class="card-img-top" alt="${profile.nickname}" style="object-fit: cover; height: 260px;">
                <div class="card-body">
                  <h5 class="card-title">${profile.nickname}</h5>
                  <p class="card-text">${profile.description}</p>
                </div>
                <div class="card-footer">
                  <small class="text-muted">${profile.city}, ${new Date(profile.dob).toLocaleDateString()}</small>
                </div>
              </div>
            </div>
          `;
          profilesGrid.append(profileCard);
        });
      },
      error: function() {
        // Error handling code
      }
    });
  });
});


// Function to create and display a popup modal for liking a profile
$(document).ready(function() {
  // Create the modal HTML structure
  var modalHtml = `
    <div id="likeModal" class="modal" style="display:none; position: fixed; z-index: 1; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgb(0,0,0); background-color: rgba(0,0,0,0.4);">
      <div class="modal-content" style="background-color: #fefefe; margin: 15% auto; padding: 20px; border: 1px solid #888; width: 80%; max-width: 500px;">
        <span class="close" style="color: #aaa; float: right; font-size: 28px; font-weight: bold;">&times;</span>
        <textarea id="messageInput" style="width: 100%; margin-bottom: 20px;" placeholder="Ваше сообщение..."></textarea>
        <button id="sendLike" style="width: 100%;">Like</button>
      </div>
    </div>
  `;
  // Function to attach photo path in a hidden input within the modal
  function attachPhotoPathToModal(photoPath) {
    // Check if the hidden input already exists
    var hiddenInput = $('#likeModal').find('#photoPathInput');
    
    if (hiddenInput.length === 0) {
      // Create hidden input to store the photo path and name
      var inputHtml = `<input type="hidden" id="photoPathInput" value="${photoPath}">
                        <input type="hidden" id="nameInput" value="${name}">`;
      // Append the hidden inputs to the modal content
      $('#likeModal .modal-content').append(inputHtml);
    
    } else {
      // Update the value of the hidden input with the new photo path
      hiddenInput.val(photoPath);
      
    }
  }

  // Event listener to handle click on profile card and open modal with photo path attached
 

  // Append the modal to the body
  $('body').append(modalHtml);

  // Function to open the modal
  function openModal() {
    $('#likeModal').show();
  }

  // Function to close the modal
  function closeModal() {
    $('#likeModal').hide();
  }

  // Event handler to open the modal
 


 $(document).on('click', '.profile-card', function() {
    // Retrieve the photo path from the card that was clicked

    var photoPath = $(this).find('.card-img-top').attr('src');
    var name = $(this).find('.card-title').text();
    // Attach the photo path to the modal
    attachPhotoPathToModal(photoPath,name);
    console.log(photoPath)
   
    // Open the modal
    openModal();
    $('#sendLike').click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      var message = $('#messageInput').val();
      var photoPath = $('#photoPathInput').val(); // Retrieve the photoPath from the hidden input
      // Add AJAX call to send the like and message to the server
      $.ajax({
        url: '/api/like',
        type: 'POST',
        data: {
          message: message,
          photo: photoPath,
          name: name,
        },
        success: function(response) {
          if (response.message == "You cannot like yourself."){
            alert(response.message)
          } 
          else if (response.message == 'You have already liked this user.'){
            alert(response.message  )
          }
          else{ 
 // Handle success
                console.log('Like sent successfully:', response);
                
          }
          $('#sendLike').unbind('click');
        return false;
        },
        error: function(xhr, status, error) {
          // Handle error
          console.error('Error sending like:', error);
        }
      });
      closeModal();
    });
  });

  // Event handler to close the modal when the close button (x) is clicked
  $(document).on('click', '.close', closeModal);

  // Event handler to close the modal when click occurs outside the modal content
  $(window).click(function(event) {
    if ($(event.target).is('#likeModal')) {
      closeModal();
    }
  });

  // Event handler for the like button within the modal
  // $('#sendLike').click(function(e) {
  //   var message = $('#messageInput').val();
  //   // Add AJAX call to send the like and message to the server
  //   // ...
  //   // Event handler for clicking on a card to get the image link
    
  //   $.ajax({
  //     url: '/api/like',
  //     type: 'POST',
      
  //     data: {
  //       message: message,
  //       photo: photoPath
  //     },
  //     success: function(response) {
  //       // Handle success
  //       console.log('Like sent successfully:', response);
  //     },
  //     error: function(xhr, status, error) {
  //       // Handle error
  //       console.error('Error sending like:', xhr.responseText);
  //     }
  //   });
  //   closeModal();
  // });
});
