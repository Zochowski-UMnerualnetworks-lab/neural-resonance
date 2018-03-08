function bootstrap_getdiff4(filename,random_begin,random_end,state,low_freq,high_freq,outpath)
expID=filename(1:end-4);
data=load(filename);
data=data.outmat;
tic
if (strcmpi(state,'all'))
    
    tbeg=data.tbeg;
    tend=data.tend;
    true_meandiff=getdiffoneexp8(data,tbeg,tend,low_freq,high_freq,0);
    rand_diff=zeros(length(true_meandiff),random_end-random_begin);
    for label=random_begin+1:random_end
        rand_diff(:,label)=getdiffoneexp8(data,tbeg,tend,low_freq,high_freq,label);
        toc
    end
    
else
    
    intervals=cell2mat(data.intervals);
    intervals_name={intervals.name};
    ind=strcmpi(intervals_name,state);
    intervals_begin=intervals(ind).intStarts;
    intervals_end=intervals(ind).intEnds;
        
    true_meandiff=getdiffoneexp8(data,intervals_begin,intervals_end,low_freq,high_freq,0);
    rand_diff=zeros(length(true_meandiff),random_end-random_begin);
    for label=random_begin+1:random_end
        rand_diff(:,label)=getdiffoneexp8(data,intervals_begin,intervals_end,low_freq,high_freq,label);
        toc
    end
end

mu=mean(rand_diff,2);
sigma=std(rand_diff,0,2);
significance=(true_meandiff-mu)./sigma;

name1=[outpath '/' expID '_' num2str(low_freq) '-' num2str(high_freq) 'Hz_'  state 'meandiff.txt'];
dlmwrite(name1,true_meandiff,'delimiter','\t','precision',15);
name2=[outpath '/' expID '_' num2str(low_freq) '-' num2str(high_freq) 'Hz_'  state 'significance.txt'];
dlmwrite(name2,significance,'delimiter','\t','precision',15);
%     name3=[outpath '/' ref_wave_name(1:end-4) state 'stat.txt'];
%     dlmwrite(name3,stat,'delimiter','\t','precision',15);
name4=[outpath '/' expID '_' num2str(low_freq) '-' num2str(high_freq) 'Hz_'  state 'randdiff.txt'];
dlmwrite(name4,rand_diff,'delimiter','\t','precision',15);
