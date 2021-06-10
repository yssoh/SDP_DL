% Script for learning data compression as projections of sparse vectors
% Body of the code

[d,n] = size(Y);          
[l,~] = size(PARAM_TABLE);

% Code
nrun = 0;
for kk = 1 : MAX_ROUNDS
for jj = 1 : l
    
    nrun = nrun + 1;
    fprintf('Experiment %d # # # # # # # # # # # # # # # # # # # # # # # # # \n',nrun)
    q = PARAM_TABLE(jj,1);
    r = PARAM_TABLE(jj,2);    
    fprintf('Dimension %d, Sparsity %d, Round %d \n',q,r,kk)
    
    % Save these % % % % % % % % % % 
    errtab_store = zeros(n_its,n);
    output_store = zeros(n_its,3);
    elapsedtime_store = zeros(n_its,1);
    
    % Load seed from seed table % % %
    seed = SEED_TABLE(nrun,1);
    rng(seed)
    
    % Initialized random A % % % % % 
    A_start = randn(d,q);
    for ll = 1 : q
        A_start(:,ll) = A_start(:,ll) / norm(A_start(:,ll),2);
    end
    
    % Begin the iterates % % % % % % 
    A = A_start;
    for ii = 1 : n_its
        tic
        [A,~,errtab,outputstat] = svam(Y(:,1:n),A,r,parmode);
        elapsedtime_store(ii,1) = toc;
        errtab_store(ii,:) = errtab;
        output_store(ii,:) = outputstat;
        fprintf('Cycle %d / %d \n',ii,n_its)
        fprintf('Approx Error: %e \n', mean(errtab))
    end

    % Save to disk % % % % % % % % % 
    PATH = strcat('instances/',DATASET,'/output/r',int2str(kk),'sv_q',int2str(q),'r',int2str(r),'.mat');
    save(PATH,'seed','r','q','A_start','A','errtab_store','output_store','elapsedtime_store')

end
end