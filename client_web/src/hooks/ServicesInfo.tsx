import axios from "axios";
import serverConfig from '../configs/ServerConfig'

interface Response {
    status: number;
    message?: string;
    services?: any;
}

export async function getListAccessServices(): Promise<Response> {
    try {
        const response = await axios.get(`${serverConfig.serverUrl}/services`);
        return { services: response.data, status: response.status };
    } catch (err: any) {
        return { message: err?.response?.data?.message, status: err.status } || { message: "Error", status: 401};
    }
}

export default getListAccessServices