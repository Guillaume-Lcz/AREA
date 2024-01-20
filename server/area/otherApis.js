import axios from 'axios';

async function getJokes() {
  try {
    const response = await axios.get(
      'https://official-joke-api.appspot.com/jokes/random',
      {
        headers: { Accept: 'application/json' },
      }
    );
    const res = response.data.setup + ' ' + response.data.punchline;
    return res;
  } catch (error) {
    console.error(error);
  }
}

async function getArt() {
  try {
    const response = await axios.get('https://api.artic.edu/api/v1/artworks');
    const data = response.data.data;
    const randomArtwork = data[Math.floor(Math.random() * data.length)];
    let res =
      'Hello ! Random artwork from the Art Institute of Chicago: \n' +
      '**' +
      randomArtwork.title +
      ' :' +
      '**' +
      `\nhttps://www.artic.edu/iiif/2/${randomArtwork.image_id}/full/843,1000/0/default.jpg`;
    return res;
  } catch (error) {
    console.error(error);
  }
}

export { getJokes, getArt };
