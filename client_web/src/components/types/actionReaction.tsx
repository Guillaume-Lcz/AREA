
export interface ReactionItem {
    name: string;
    description: string;
    data: any;
}

export const action: { [key: string]: ReactionItem[] } = {
    "discord": [
    ],
    "spotify": [
        {
            name: "last_playlist",
            description: "Triggers when a new playlist is added or created",
            data: {}
        },
        {
            name: "last_song",
            description: "Triggers when a new song is listened",
            data: {}
        },
        {
            name: "last_album",
            description: "Triggers when a new album is added or listened",
            data: {}
        }
    ],
    "timer": [
        { name: "every_day", description: "trigger a reaction every hour you want", data: { hour: 0, minute: 0 } },
        { name: "every_month", description: "trigger a reaction every day you want", data: { day: 0, hour: 0 } },
        { name: "at_specific_date_time", description: "trigger a reaction on the day you want", data: { year: 0, month: 0, day: 0, hour: 0 } },
    ],
    "gmail": [
        { name: "last_mail", description: "Triggers when a new mail is got", data: {} },
        { name: "last_mail_from_someone", description: "Triggers when a new mail is got from someone", data: { sender: "" } },
    ],
    "drive": [
        { name: "get_folder_action", description: "Trigger to get action from a folder", data: { folder_name: ""} },
    ]
}

export const reaction: { [key: string]: ReactionItem[] } = {
    "discord": [
        { name: "post_message", description: "post discord message to a channel", data: { channel_id: "", body: "" } },
        { name: "post_joke", description: "post discord random joke message to a channel", data: { channel_id: "" } },
        { name: "post_art", description: "post discord random art from the met to a channel", data: { channel_id: "" } },
    ],
    "spotify": [
    ],
    "timer": [
    ],
    "gmail": [
        { name: "send_mail", description: "Send a mail to someone", data: { to: "", subject: "", body: "" } },
    ],
    "drive": [
        { name: "new_file", description: "Create a new file in a folder", data: { folder_name: "", file_name: "", file_content: "" } },
    ]
};
