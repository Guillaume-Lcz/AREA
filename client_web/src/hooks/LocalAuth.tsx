import axios from "axios";
import serverConfig from '../configs/ServerConfig'

interface SignUpResponse {
    status: number;
    message?: string;
    user?: any;
}

export async function LocalAuthSignUp(name: string, email: string, password: string): Promise<SignUpResponse> {
    try {
        const response = await axios.post(`${serverConfig.serverUrl}/auth/local/sign-up`, {
            name,
            email,
            password,
        }, {
            withCredentials: true,
        });
        return { user: response.data.user, status: response.status };
    } catch (err: any) {
        return { message: err?.response?.data?.message, status: err.status } || { message: "Error", status: 401};
    }
}

interface SignInResponse {
    status: number;
    message?: string;
    user?: any;
}

export async function LocalAuthSignIn(email: string, password: string): Promise<SignInResponse> {
    try {
        const response = await axios.post(`${serverConfig.serverUrl}/auth/local/sign-in`, {
            email,
            password,
        }, {
            withCredentials: true,
        });
        return { user: response.data.user, status: response.status };
    } catch (err: any) {
        return { message: err?.response?.data?.message, status: err.status } || { message: "Error", status: 401};
    }
}

export async function LocalAuthLogout() {
    try {
        await axios.post(`${serverConfig.serverUrl}/auth/logout`);
    } catch (err) {
    }
}

export default { LocalAuthSignUp, LocalAuthSignIn };