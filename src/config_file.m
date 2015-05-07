%signals according to TEAP terms
%possible values 'EEG','GSR','HST','RES','BVP', ECG'

%this is an example based on the DEAP Dataset (bdf file)
signals = {'EEG','GSR','HST','RES','BVP'};
%electrode lables in the file where they are recorded
electrode_labels.GSR = {'GSR1'};
electrode_labels.HST = {'Temp'};
electrode_labels.RES = {'Resp'};
electrode_labels.BVP = {'Plet'};
%electrode_labels.ECG = {'EXG1','EXG2','EXG3'};%mahnob

%EEG electrod labels
electrode_labels.EEG  = {'Fp1', 'AF3', 'F3', 'F7', 'FC5', 'FC1', 'C3', 'T7', 'CP5', ...
            'CP1', 'P3', 'P7', 'PO3', 'O1', 'Oz', 'Pz', 'Fp2', 'AF4', ...
            'Fz', 'F4', 'F8', 'FC6', 'FC2', 'Cz', 'C4', 'T8', 'CP6', ...
            'CP2', 'P4', 'P8', 'PO4', 'O2'};