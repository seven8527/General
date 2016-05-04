package com.zhicheng.collegeorange;

import android.os.AsyncTask;



/**
 * Created by ypyang on 3/8/16.
 */
public abstract class ModelTask extends AsyncTask<Void, Void, String> {
    public static enum KEY {
        PageTaskMessage, InitialAction, PageTaskAction, isPageTaskRunning
    }

    protected String action;

    protected Model model;
    protected boolean isRunInStart = false;

    protected ModelTask(Model model) {
        this(model, false);
    }

    protected ModelTask(Model model, boolean isRunInStart) {
        this.model = model;
        this.isRunInStart = isRunInStart;
        //default action is InitialAction
        this.action = KEY.InitialAction.name();
    }

    public boolean isRunInStart() {
        return isRunInStart;
    }

    @Override
    protected void onPreExecute() {
        if (isCancelled()) {
            return;
        }
        model.onPreExecute(action);
    }

    @Override
    protected void onPostExecute(String jsonString) {
        if (isCancelled()) {
            return;
        }
        model.onPostExecute(jsonString);
    }

    public void cancelTask() {
        super.cancel(false);
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }
}
