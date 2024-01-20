import React, { useEffect, useState } from "react";
import "../../styles/ServicePage.css";
import { BoardServices } from "./BoardServices";
import NavBar from "../atoms/NavBar";
import InformationInput from "./InformationInput";
import { getMyInfoUser } from "../../hooks/UserInfo";
import { Service } from "../types/service";

function isServiceEnabled(services: any[], serviceName: string) {
    for (const service of services) {
        if (service[serviceName]) {
            return true;
        }
    }
    return false;
}

export function ServicePage({ setPageService, service, actionReaction, ActionReactionCallback, servicesConnected }: ServicePageProps) {
    const connect_button = service.required.connect_button;
    const [infoPageActivate, setInfoPage] = useState(false);
    const [newService, setNewService] = useState<Service>({} as Service);

    const openNewWindow = (url: string) => {
        window.open(url, "_blank");
    };

    const goButton = (index: number) => {
        if (connect_button && !(isServiceEnabled(servicesConnected, service.required.service))) {
            alert(`require a ${service.required.service} connection`)
            return;
        }
        const copyActionReaction = { ...actionReaction };
        copyActionReaction.data = copyActionReaction.data[index];
        const newServiceCopy = {
          actionReaction: { ...copyActionReaction },
          service: { ...service },
        };
        setNewService(newServiceCopy);
        setInfoPage(true);
    };

    return (
        infoPageActivate ? (
            <InformationInput setInfoPage={setInfoPage} newService={newService} setNewService={setNewService} ActionReactionCallback={ActionReactionCallback} />
        ) : (
            <div className="service-page-container">
                <img className="logo-service" src={service.image} alt="Logo" />

                {connect_button ? (isServiceEnabled(servicesConnected, service.required.service) ? `Connected to ${service.name} 🟢` : `Not Connected to ${service.name} 🔴`) : actionReaction.data.length == 0 ? "Nothing yet" : ""}
                {connect_button && (
                    <button className="connect-button" style={{ backgroundColor: service.color }} onClick={() => { openNewWindow(service.required.redirect) }}>
                        {((isServiceEnabled(servicesConnected, service.required.service)) ? `Reconnect to ${service.name}` : `Connect to ${service.name}`)}
                    </button>
                )}
                {actionReaction.data.map((data: any, index: number) => (
                    <button key={index} className="action-reaction-button" onClick={() => { goButton(index) }}>
                        {data.name.replace(/_/g, " ")}
                    </button>
                ))}
                <button className="back-button" onClick={() => setPageService(false)}>
                    Back
                </button>
            </div>
        )
    );
}

export interface ServicePageProps {
    setPageService: React.Dispatch<React.SetStateAction<boolean>>;
    service: any;
    actionReaction: any;
    ActionReactionCallback: (selectedService: Service) => void;
    servicesConnected: any
}

export default ServicePage;
