import React, { useEffect, useState } from "react";
import { deleteActionReaction, getActionReaction } from "../../hooks/ProjectInfo";
import "../../styles/MyTasks.css";

export function MyTasks(_: MyTasksProps) {
  const [tasks, setTasks] = useState<any[] | undefined>(undefined);

  useEffect(() => {
    const getList = async () => {
      const myTasks = await getActionReaction();
      setTasks(myTasks?.project || []);
    };
    getList();
  }, []);

  const handleDescriptionReaction = (reactionData: any) => {
    alert(`service: ${reactionData.service}\nname_task: ${reactionData.name}\nDescription: ${reactionData.description}\ndata: ${JSON.stringify(reactionData.data)}`);
  };
  const handleDescriptionAction = (action: any) => {
    alert(`service: ${action.service}\nname_task: ${action.name}\nDescription: ${action.description}\ndata: ${JSON.stringify(action.data)}`);
  };
  const deleteTask = async (data: any) => {
    await deleteActionReaction(data._id);
    if (tasks) {
        setTasks(tasks.filter(task => task._id != data._id));
    }
  }

  return (
    <>
    <h1>Task Manager</h1>
      {tasks && tasks.length === 0 ? (
        <p>No task in progress</p>
      ) : (
        tasks &&
        tasks.map((data: any, index) => (
          <div key={index} className="task-list">
            <div className="task-header" onClick={() => {deleteTask(data)}}>Delete</div>
            <div className="task-item action" onClick={() => handleDescriptionAction(data.action)}>
            <div >
              {`Action - ${data.action.service}`}
            </div>
              <div className="button-container">
              </div>
            </div>
            {data.reaction.map((reactionData: any, reactionIndex: number) => (
              <div key={reactionIndex} className="task-item reaction" onClick={() => handleDescriptionReaction(reactionData)} >
                <div>
                {`Reaction ${reactionIndex} - ${reactionData.name}`}
                </div>
                <div className="button-container">
                </div>
              </div>
            ))}
          </div>
        ))
      )}
    </>
  );
}

export interface MyTasksProps {}

export default MyTasks;
