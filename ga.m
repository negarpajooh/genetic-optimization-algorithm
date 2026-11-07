clc;
clear;
close all;
global NFE Max_x1 Min_x1 Max_x2 Min_x2 Max_y1 Min_y1  Max_y2 Min_y2
%%
Max_x1=input('plz enter Max x1 = ');
Min_x1=input('plz enter Min x1 = ');
disp('-------------------------------------')
Max_x2=input('plz enter Max x2 = ');
Min_x2=input('plz enter Min x2 = ');
disp('-------------------------------------')
Max_y1=input('plz enter Max y1 = ');
Min_y1=input('plz enter Min y1 = ');
disp('-------------------------------------')
Max_y2=input('plz enter Max y2 = ');
Min_y2=input('plz enter Min y2 = ');
disp('-------------------------------------')
%
%% 
NFE=0;
CostFunction=@(x) CF(x);     
nVar=1;            
VarSize=[1 nVar];  
VarMin=Min_x1;        
VarMax=Max_x1;        
%% 
MaxIt=100;      
nPop=100;       
pc=0.8;               
nc=2*round(pc*nPop/2);  
pm=0.3;                
nm=round(pm*nPop);     
gamma=0.05;
mu=0.02;       
ANSWER='Roulette Wheel';
UseRouletteWheelSelection=strcmp(ANSWER,'Roulette Wheel');
    beta=8;        
pause(0.1);
%%
empty_individual.Position=[];
empty_individual.Cost=[];
pop=repmat(empty_individual,nPop,1);
for i=1:nPop
    % 
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    % 
    pop(i).Cost=CostFunction(pop(i).Position);
end
% 
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);
% 
BestSol=pop(1);
%
BestCost=zeros(MaxIt,1);
% 
WorstCost=pop(end).Cost;
% 
nfe=zeros(MaxIt,1);
%% 
for it=1:MaxIt   
    % 
    if UseRouletteWheelSelection
        P=exp(-beta*Costs/WorstCost);
        P=P/sum(P);
    end   
    % 
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2
        % 
        if UseRouletteWheelSelection
            i1=RouletteWheelSelection(P);
            i2=RouletteWheelSelection(P);
        end
        % 
        p1=pop(i1);
        p2=pop(i2);
        % 
        [popc(k,1).Position popc(k,2).Position]=...
            Crossover(p1.Position,p2.Position,gamma,VarMin,VarMax);
        % 
        popc(k,1).Cost=CostFunction(popc(k,1).Position);
        popc(k,2).Cost=CostFunction(popc(k,2).Position);
        
    end
    popc=popc(:);   
    %
    popm=repmat(empty_individual,nm,1);
    for k=1:nm  
        % 
        i=randi([1 nPop]);
        p=pop(i);
        % 
        popm(k).Position=Mutate(p.Position,mu,VarMin,VarMax);
        % 
        popm(k).Cost=CostFunction(popm(k).Position); 
    end
    %
    pop=[pop
         popc
         popm];
    %
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    % 
    WorstCost=max(WorstCost,pop(end).Cost);
    % 
    pop=pop(1:nPop);
    Costs=Costs(1:nPop);    
%
    BestSol=pop(1);    
%
    BestCost(it)=BestSol.Cost; 
% 
    nfe(it)=NFE;
end
%% 
figure;
plot(nfe,BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Fit');
title('Genetic Algorithm Optimization')
grid minor
%% 
x1=BestCost(end);
x2=(BestCost(end)*(Max_x2-Min_x2))/(Max_x1-Min_x1);
y1=(BestCost(end)*(Max_y1-Min_y1))/(Max_x1-Min_x1);
y2=(BestCost(end)*(Max_y2-Min_y2))/(Max_x1-Min_x1);
func=((x1-x2)^2)+((y1-y2)^2);
disp('--------------------------------------------------')
disp('| Result |')
disp('--------------------------------------------------')
disp(['Best x1 = ',num2str(x1)])
disp(['Best x2 = ',num2str(x2)])
disp(['Best y1 = ',num2str(y1)])
disp(['Best y2 = ',num2str(y2)])
disp(['Minimum((x1-x2)^2+((y1-y2)^2)= ',num2str(func)])