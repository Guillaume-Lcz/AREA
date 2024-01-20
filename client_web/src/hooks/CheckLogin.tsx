import axios from "axios";
import serverConfig from '../configs/ServerConfig';

export async function CheckLogin() {
  try {
    return await axios.get(`${serverConfig.serverUrl}/auth/echo`);
  } catch (err) {
    return null;
  }
}

export default CheckLogin;
