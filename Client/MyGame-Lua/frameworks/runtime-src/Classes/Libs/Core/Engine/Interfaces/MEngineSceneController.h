#pragma once
#ifndef __MEngineSceneController_H__
#define __MEngineSceneController_H__

/**
* This interface defines methods that any class that is to be used as an scene controller must implement.
* An scene controller is used to program specific behaviours associated to an scene.
*/
class MEngineSceneController
{
public:
	MEngineSceneController();
	~MEngineSceneController();

	/**
	* This is the initialization method
	*
	* @param character The fElement that will be controlled by this class.
	*/
	void assignScene(MScene scene);

	/**
	* This is used to enable the controller. In complex applications, you will want to enable / disable controllers as you enter / leave scenes,
	* when you trigger a cutscene, pause your game, go to the Options menu, etc etc
	*/
	void enable();

	/**
	* This is used to disable the controller. In complex applications, you will want to enable / disable controllers as you enter / leave scenes,
	* when you trigger a cutscene, pause your game, go to the Options menu, etc etc
	*/
	void disable();
};

#endif