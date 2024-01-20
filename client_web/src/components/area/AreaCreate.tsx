import React, { useState } from "react";
import "../../styles/AreaCreate.css";
import { BoardServices } from "./BoardServices";
import NavBar from "../atoms/NavBar";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../../context/AuthContextProvider";
import { Service, ServiceActionReaction } from "../types/service";
import { postActionReaction } from "../../hooks/ProjectInfo";

interface AreaCreateProps { }

const ActionReactionSave = (action: Service, reaction: Service[]): ServiceActionReaction => {
    return {
        action: {
            description: action.actionReaction.data.description,
            service: action.service.name.toLowerCase(),
            name: action.actionReaction.data.name,
            data: action.actionReaction.data.data,
        },
        reaction: reaction.map((block) => ({
            service: block.service.name.toLowerCase(),
            description: block.actionReaction.data.description,
            name: block.actionReaction.data.name,
            data: block.actionReaction.data.data,
        })),
    };
};

export function AreaCreate(_: AreaCreateProps) {
    const [ifBlock, setIfBlock] = useState<Service[]>([]);
    const [blocks, setBlocks] = useState<Service[]>([]);
    const [boardActivate, setBoardActivate] = useState(false);
    const [isAction, setisAction] = useState(false);
    const { loggedIn } = useAuth();
    const navigate = useNavigate();

    if (!loggedIn) {
        navigate("/");
        return null;
    }

    const handleDescriptionReaction = (index: number) => {
        alert(`service_name: ${blocks[index].service.name}\nname_task: ${blocks[index].actionReaction.data.name}\ndescription: ${blocks[index].actionReaction.data.description}\ndata: ${JSON.stringify(blocks[index].actionReaction.data.data)}`)
    };

    const handleDescriptionAction = () => {
        if (ifBlock.length != 0) {
            alert(`service_name: ${ifBlock[0].service.name}\nname_task: ${ifBlock[0].actionReaction.data.name}\ndescription: ${ifBlock[0].actionReaction.data.description}\ndata: ${JSON.stringify(ifBlock[0].actionReaction.data.data)}`)
        }
    };

    const handleSave = async () => {
        if (ifBlock.length === 0 && !blocks.some(block => block.actionReaction.isAction)) {
            alert("Please add at least one action block before saving.");
        } else {
            const response = await postActionReaction(ActionReactionSave(ifBlock[0], blocks));
            if (response.status == 201) {
                alert(response.project);
                navigate("/home");
            } else {
                alert(response.message);
            }
        }
    }

    const openBoardServices = (isAction: boolean) => {
        setisAction(isAction);
        setBoardActivate(!boardActivate);
    };

    const ActionReactionCallback = (service: Service) => {
        if (service.actionReaction.isAction) {
            setIfBlock([service]);
        } else {
            setBlocks((prevBlocks) => [...prevBlocks, service]);
        }
        setBoardActivate(false);
    };

    const removeBlock = (index: number) => {
        const updatedBlocks = [...blocks];
        updatedBlocks.splice(index, 1);
        setBlocks(updatedBlocks);
    };

    return (
        <>
            <NavBar />
            {boardActivate ? (
                <BoardServices isAction={isAction} setBoardActivate={setBoardActivate} ActionReactionCallback={ActionReactionCallback} />
            ) : (
                <>
                    <h1>Create Area</h1>
                    <div className="area-create-container">
                        <div className="if-condition">
                            <div onClick={handleDescriptionAction}>
                                <p >If {ifBlock.map((service) => service.service.name)}</p>
                            </div>
                            <button className="button-plus" onClick={() => { openBoardServices(true) }}>
                                {ifBlock.length == 0 ? "+" : "✏️"}
                            </button>
                        </div>
                        <div className="then-condition">
                            <button className="button" onClick={() => { openBoardServices(false) }}>
                                Then do
                            </button>
                        </div>
                        <div className="added-blocks">
                            {blocks.map((block, index) => (
                                <div key={index} style={{ backgroundColor: block.service.color }} className="block">
                                    <div onClick={() => { handleDescriptionReaction(index) }}>
                                        <p>{block.service.name}</p>
                                    </div>
                                    <button className="delete-button" onClick={() => removeBlock(index)}>
                                        &#10006;
                                    </button>
                                </div>
                            ))}
                        </div>
                    </div>
                    <button className="save-button" onClick={() => handleSave()}>
                        Save
                    </button>
                    <button className="back-button" onClick={() => navigate("/home")}>
                        Back
                    </button>
                </>
            )}
        </>
    );
}

export default AreaCreate;
