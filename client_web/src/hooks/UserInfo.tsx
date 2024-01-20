import axios from "axios";
import serverConfig from '../configs/ServerConfig'

interface Response {
    status: number;
    message?: string;
    user?: any;
}

export async function getMyInfoUser(): Promise<Response> {
    try {
        const response = await axios.get(`${serverConfig.serverUrl}/user`);
        return { user: response.data, status: response.status };
    } catch (err: any) {
        return { message: err?.response?.data?.message, status: err.status } || { message: "Error", status: 401};
    }
}

export async function deleteTheUser(): Promise<Response> {
    try {
        const response = await axios.delete(`${serverConfig.serverUrl}/user/delete`);
        return { user: response.data, status: response.status };
    } catch (err: any) {
        return { message: err?.response?.data?.message, status: err.status } || { message: "Error", status: 401};
    }
}

export default { getMyInfoUser, deleteTheUser }