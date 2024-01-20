import React, { useEffect, useState } from "react";
import "../../styles/InformationInput.css";
import { Service } from "../types/service";

export interface InformationInputProps {
    setInfoPage: React.Dispatch<React.SetStateAction<boolean>>;
    newService: Service;
    setNewService: React.Dispatch<React.SetStateAction<Service>>;
    ActionReactionCallback: (selectedService: Service) => void;
}

const getInputType = (value: any): string => {
    if (typeof value === "number") {
        return "number";
    }
    return "text";
};

const convertMyValue = (type: any, value: any) => {
    switch (type) {
        case 'string':
            return String(value);
        case 'number':
            return Number(value);
        case 'boolean':
            return value.toLowerCase() === 'true';
        default:
            return value;
    }
};
export function InformationInput({setInfoPage, newService, setNewService, ActionReactionCallback}: InformationInputProps) {
    const [formData, setFormData] = useState<Service>(newService);

    const handleInputChange = (key: string, value: string) => {
        setFormData((prevData) => ({
            ...prevData,
            actionReaction: {
                ...prevData.actionReaction,
                data: {
                    ...prevData.actionReaction.data,
                    data: {
                        ...prevData.actionReaction.data.data,
                        [key]: convertMyValue(getInputType(prevData.actionReaction.data.data[key]), value),
                    },
                },
            },
        }));
    };

    const validate = () => {
        const allFieldsFilled = Object.values(formData.actionReaction.data.data).every(
            (val: unknown) =>
                (typeof val === 'string' && (val as string).trim() !== '') ||
                (typeof val === 'number' && !isNaN(val))
        );
        if (allFieldsFilled) {
            ActionReactionCallback(formData);
        } else {
            alert("Please complete all fields before saving.");
        }
    };

    return (
        <div className="information-input-container">
            <div className="input-section">
                <img src={formData.service.image} alt="Logo" className="info-logo" />
                <h2 className="custom-title">{formData.actionReaction.data.name.replace(/_/g, " ")}</h2>
                <p className="custom-description">{formData.actionReaction.data.description}</p>
                {Object.keys(formData.actionReaction.data.data).map((key, index) => (
               <input
               key={index}
               type={getInputType(newService.actionReaction.data.data[key])}
               placeholder={key.replace(/_/g, " ")}
               value={formData.actionReaction.data.data[key] || null}
               required
               onChange={(e) => handleInputChange(key, e.target.value)}
               className="custom-input"
           />
                ))}
                <button className="save-button custom-save-button" onClick={validate}>
                    Save
                </button>
                <button className="back-button" onClick={() => setInfoPage(false)}>
                    Back
                </button>
            </div>
        </div>
    );
}

export default InformationInput;
