import React, { useState, useEffect } from "react";
import "../../styles/BoardServices.css";
import ServicePage from "./ServicePage";
import getListAccessServices from "../../hooks/ServicesInfo";
import { action, reaction } from "../types/actionReaction";
import { Service, dummyServices } from "../types/service";
import { getMyInfoUser } from "../../hooks/UserInfo";

export interface Services {
    name: string;
    image: string;
    color: string;
    title: string;
    required: {service: string}
}

export interface BoardServicesProps {
    setBoardActivate: React.Dispatch<React.SetStateAction<boolean>>;
    isAction: boolean;
    ActionReactionCallback: (selectedService: Service) => void;
}

interface ServiceItem {
    [key: string]: boolean;
}

export function BoardServices({ setBoardActivate, isAction, ActionReactionCallback}: BoardServicesProps) {
    const [services, setServices] = useState<Services[]>([]);
    const [servicesConnected, setServicesConnected] = useState<any[]>([]);
    const [pageService, setPageService] = useState(false);
    const [idService, setIdService] = useState(0);
    const [CheckConnected, setCheckConnected] = useState(false);

    const getList = async () => {
        const redirectServices = await getListAccessServices();
        setServices(dummyServices(redirectServices) || []);
    };

   const getServicesConnected = async () => {
    const redirectServices = await getMyInfoUser();
    setServicesConnected(redirectServices?.user?.services || []);
    if (services) {
        setCheckConnected(Array.isArray(redirectServices?.user?.services) &&
            redirectServices.user.services.some((item: ServiceItem) =>
                Object.keys(item).includes(services[idService]?.required?.service)
            )
        );
    }
};

    useEffect(() => {
        getList();
        getServicesConnected();
        const intervalId = setInterval(() => {
            if (CheckConnected) {
                clearInterval(intervalId);
            }
            getServicesConnected();
        }, 5000);
        return () => clearInterval(intervalId);
    }, []);

    const handleServiceClick = (index: number) => {
        setIdService(index)
        setPageService(true)
    };

    return (
        <>
            {pageService ? (
                <ServicePage
                setPageService={setPageService}
                servicesConnected={servicesConnected}
                actionReaction={{
                  data: isAction
                    ? action[String(services[idService].name.toLowerCase())]
                    : reaction[String(services[idService].name.toLowerCase())],
                  isAction: isAction
                }
                }
                ActionReactionCallback={ActionReactionCallback}
                service={services[idService]}
              />) :
                <div className="board-container active">
                    <div className="services-board">
                        {services.map((service, index) => (
                            <button
                                key={index}
                                className="service-block"
                                style={{ backgroundColor: service.color }}
                                onClick={() => handleServiceClick(index)}
                            >
                                <img src={service.image} alt={service.name} />
                                <div className="service-name">{service.title}</div>
                            </button>
                        ))}
                    </div>
                    <button className="back-button" onClick={() => setBoardActivate(false)}>
                        Back
                    </button>
                </div>}
        </>
    );
}
