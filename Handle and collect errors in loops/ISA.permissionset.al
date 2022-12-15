permissionset 50302 ISA_GenerPermission
{
    Assignable = true;
    Permissions = tabledata ISA_ErrorLog=RIMD,
        tabledata ISA_TransactionSimulator=RIMD,
        table ISA_ErrorLog=X,
        table ISA_TransactionSimulator=X,
        codeunit ISA_RunProcess=X,
        page ISA_ErrorLogList=X;
}