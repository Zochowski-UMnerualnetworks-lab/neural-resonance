function meanAmplitude=getdiffoneexp8(data,intervals_begin,intervals_end,low_freq,high_freq,random_label)

neuron=cell2mat(data.neurons);
num_neuron=length(neuron);
contvars=cell2mat(data.contvars);

alltimestamps={neuron.timestamps}';
alltimestamps=unique(cell2mat(alltimestamps));
tbeg=floor(alltimestamps(1));

no_electrode=arrayfun(@(x) str2double(x.name(end-1:end)), contvars);
no_neuron=arrayfun(@(x) str2double(x.name(end-2:end-1)), neuron);

windowHalfWidth=ceil(500/low_freq);

meanAmplitude=zeros(num_neuron,1);
for i=1:num_neuron
    fprintf('i=%d\n',i);
    spikes=neuron(i).timestamps;
    index=false(length(spikes),1);
    x=(no_electrode==no_neuron(i));
     
    raw_wave=contvars(x).data;
    [sos,g]=GetBandpassFilterSos(low_freq,high_freq,1000);
    ref_wave=filtfilt(sos,g,raw_wave);

    time=1000*tbeg+(1:length(ref_wave));
    
    for j=1:length(intervals_begin)
        index=index+(spikes>=intervals_begin(j) & spikes<intervals_end(j));
    end
    spikes=spikes(logical(index));
    random_shift=(rand(length(spikes),1)-0.5)*10*windowHalfWidth*2/1000;    %change random range
    spikes=spikes+logical(random_label)*random_shift;
    
    spikeintMs = spikes*1000;
    windowLeft = spikeintMs - windowHalfWidth;
    windowRight = spikeintMs + windowHalfWidth;
    iValid = windowLeft >= min(time) & windowRight <= max(time);
    timeOffset = min(time) - 1;
    windowLeft = round(windowLeft(iValid)) - timeOffset;
    windowRight = windowLeft + windowHalfWidth*2;
    
    waveData = zeros(windowHalfWidth*2 + 1, 1);
    nWindows = length(windowLeft);
    for j = 1:nWindows
        waveData = waveData + ref_wave(windowLeft(j):windowRight(j));
    end
    meanOscillation = waveData / nWindows;
    meanAmplitude(i) = max(meanOscillation) - min(meanOscillation);
end