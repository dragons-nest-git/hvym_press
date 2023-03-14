// Issue tokens after depositing DERO (Convert DERO to TOKENX)
Function IssueTOKENX() Uint64 
10  SEND_ASSET_TO_ADDRESS(SIGNER(), DEROVALUE(),SCID())   // Increment balance of user, without knowing original balance, this is done homomorphically
20  RETURN 0
End Function

// Convert TOKENX to DERO after depositing TOKENX. Smart Contract can give DERO, Only if DERO balance exists.
Function ConvertTOKENX() Uint64
10  SEND_DERO_TO_ADDRESS(SIGNER(),ASSETVALUE(SCID()))   // Increment balance of user, without knowing original balance, this is done using Homomorphic Encryption.
20  RETURN 0
End Function

// This function is used to initialize parameters during install time
// InitializePrivate initializes a private SC
Function InitializePrivate() Uint64
10  STORE("owner", SIGNER())   // Store in DB  ["owner"] = address

// This function is used to change owner 
// owner is an string form of address 
Function TransferOwnership(newowner String) Uint64 
10  IF LOAD("owner") == SIGNER() THEN GOTO 30 
20  RETURN 1
30  STORE("tmpowner",ADDRESS_RAW(newowner))
40  RETURN 0
End Function

// Until the new owner claims ownership, existing owner remains owner
Function ClaimOwnership() Uint64 
10  IF LOAD("tmpowner") == SIGNER() THEN GOTO 30 
20  RETURN 1
30  STORE("owner",SIGNER()) // ownership claim successful
40  RETURN 0
End Function

// if signer is owner, withdraw any requested funds
// if everthing is okay, they will be showing in signers wallet
// if signer is owner, provide him rights to update code anytime
// make sure update is always available to SC
Function UpdateCode( code String) Uint64 
10  IF LOAD("owner") == SIGNER() THEN GOTO 30 
20  RETURN 1
30  UPDATE_SC_CODE(code)
40  RETURN 0
End Function