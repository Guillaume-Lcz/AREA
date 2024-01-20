import axios from "axios";
import serverConfig from '../configs/ServerConfig'
import { ServiceActionReaction } from "../components/types/service";

interface Response {
    status: number;
    message?: string;
    project?: any;
}

export async function postActionReaction(ActionReaction: ServiceActionReaction): Promise<Response> {
    try {
        const response = await axios.post(`${serverConfig.serverUrl}/project`, ActionReaction);
        return { project: response.data, status: response.status };
    } catch (err: any) {
        return { message: err?.response?.data?.message, status: err.status } || { message: "Error", status: 401};
    }
}

export async function putActionReaction(ActionReaction: ServiceActionReaction, id: number): Promise<Response> {
    try {
        const response = await axios.put(`${serverConfig.serverUrl}/project/${id}`, ActionReaction);
        return { project: response.data, status: response.status };
    } catch (err: any) {
        return { message: err?.response?.data?.message, status: err.status } || { message: "Error", status: 401};
    }
}

export async function deleteActionReaction(id: number): Promise<Response> {
    try {
        const response = await axios.delete(`${serverConfig.serverUrl}/project/${id}`);
        return { project: response.data, status: response.status };
    } catch (err: any) {
        return { message: err?.response?.data?.message, status: err.status } || { message: "Error", status: 401};
    }
}

export async function getActionReaction(): Promise<Response> {
    try {
        const response = await axios.get(`${serverConfig.serverUrl}/project/`);
        return { project: response.data, status: response.status };
    } catch (err: any) {
        return { message: err?.response?.data?.message, status: err.status } || { message: "Error", status: 401};
    }
}


export default { postActionReaction }