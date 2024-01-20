const axios = require('axios');

async function getArt() {
// Fetch a random artwork from the Metropolitan Museum of Art API
axios.get('https://collectionapi.metmuseum.org/public/collection/v1/objects')
  .then(response => {
    const objectIDs = response.data.objectIDs;
    const randomID = objectIDs[Math.floor(Math.random() * objectIDs.length)];
    return axios.get(`https://collectionapi.metmuseum.org/public/collection/v1/objects/${randomID}`);
  })
  .then(response => {
    console.log('Random artwork from the Metropolitan Museum of Art:', {
      title: response.data.title,
      image: response.data.primaryImage
    });
  })
  .catch(error => {
    console.error(error);
  });
}

getArt();

// Fetch a random artwork from the Art Institute of Chicago API

async function getArt2() {
axios.get('https://api.artic.edu/api/v1/artworks')
  .then(response => {
    const data = response.data.data;
    const randomArtwork = data[Math.floor(Math.random() * data.length)];
    let res =
      "Hello ! Random artwork from the Art Institute of Chicago: " +
      randomArtwork.title +
      `https://www.artic.edu/iiif/2/${randomArtwork.image_id}/full/843,1000/0/default.jpg`;
    console.log(res);
  })
  .catch(error => {
    console.error(error);
  });
}

async function getJokes() {
    let res;
    axios.get('https://official-joke-api.appspot.com/jokes/random', {
      headers: { 'Accept': 'application/json' }
    })
      .then(response => {
        res = response.data.setup + " " + response.data.punchline;
        console.log(res);
      })
      .catch(error => {
        console.error(error);
      });
      return res;
}

//getJokes();
