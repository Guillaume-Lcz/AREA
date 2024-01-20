export const dummyServices = (redirectServices: any) => {
    console.log(redirectServices?.services)
    return [
        { name: "discord", title: "Discord", image: "/img/discord-logo.png", color: "#677bc4", required: { connect_button: true, service: "discord", redirect: redirectServices?.services?.discord?.redirect } },
        { name: "spotify", title: "Spotify", image: "/img/spotify-logo.png", color: "#2ecc71", required: { connect_button: true, service: "spotify", redirect: redirectServices?.services?.spotify?.redirect } },
        { name: "gmail", title: "Gmail", image: "/img/gmail-logo.png", color: "#f08b09", required: { connect_button: true, service: "google", redirect: redirectServices?.services?.google?.redirect } },
        { name: "drive", title: "Drive", image: "/img/drive-logo.png", color: "#3bb70f", required: { connect_button: true, service: "google", redirect: redirectServices?.services?.google?.redirect } },
        { name: "timer", title: "Timer", image: "/img/timer-logo.png", color: "#e74c3c", required: { connect_button: false, service: "timer", redirect: null } },
    ];
}

export interface Service {
    actionReaction: {
        data: {
            name: string;
            description: string;
            data: any;
        };
        isAction: boolean;
    };
    service: {
        name: string;
        image: string;
        color: string;
        required: {
            connect_button: boolean;
            redirect: string | null;
        };
    };
}

export interface Data {
    hour: number;
    minute: number;
}

export interface Action {
    description: string;
    service: string;
    name: string;
    data: Data;
}

export interface Reaction {
    service: string;
    description: string;
    name: string;
    data: { id: string; body: string };
}

export interface ServiceActionReaction {
    action: Action;
    reaction: Reaction[];
}