import axios from "axios";
import serverConfig from '../configs/ServerConfig'

export async function GoogleAuth() {
  try {
    const { data: { url } } = await axios.get(`${serverConfig.serverUrl}/auth/google/url`);
    return url.toString();
  } catch (err) {
    return null;
  }
}

export default GoogleAuth;