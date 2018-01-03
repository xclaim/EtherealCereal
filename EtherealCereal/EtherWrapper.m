#import "EtherWrapper.h"
#import <Ether/secp256k1.h>
#import <Ether/secp256k1_recovery.h>
#import "keccak.h"

@implementation EtherWrapper

- (NSString * _Nonnull)generateAddressFromPublicKey:(NSData * _Nonnull)publicKey {
    NSData *fullAddress = [publicKey sha3:256];
    NSData *address = [fullAddress subdataWithRange:NSMakeRange(12, fullAddress.length - 12)];

    return [@"0x" stringByAppendingString:[address hexadecimalString]];
}

-  (NSString * _Nonnull)generatePublicKeyFromMessage:(NSData * _Nonnull)message withSignature:(NSData * _Nonnull)signature  {
    const unsigned char *_message = (const unsigned char *)message.bytes;
    const unsigned char *signature_bytes = (const unsigned char *)signature.bytes;
    
    const unsigned char *msg32 = [message sha3:256].bytes;

    unsigned char signature_serialised[64];
    
    for (int i = 0; i < 64; i++) {
        signature_serialised[i] = signature_bytes[i];
    }
    int recid = signature_bytes[64];

    secp256k1_ecdsa_recoverable_signature _signature;
    unsigned char public_key_serialized[65];
    
    size_t public_key_length = 65;
    
    secp256k1_pubkey public_key;
    const secp256k1_context *ctx = secp256k1_context_create(SECP256K1_CONTEXT_VERIFY);
    
    secp256k1_ecdsa_recoverable_signature_parse_compact(ctx, &_signature,signature_serialised,recid);

    secp256k1_ecdsa_recover(ctx, &public_key, &_signature, msg32);
    
    secp256k1_ec_pubkey_serialize(ctx, public_key_serialized, &public_key_length, &public_key, SECP256K1_EC_UNCOMPRESSED);
    
    NSData *publicKeyData = [[NSData dataWithBytes:public_key_serialized length:public_key_length] subdataWithRange:NSMakeRange(1, public_key_length - 1)];
    
    NSString *publicKeyString = [publicKeyData hexadecimalString];

    return publicKeyString;
}

-  (NSData * _Nonnull)generatePublicKeyFromPrivateKey:(NSData * _Nonnull)privateKey {
    const unsigned char *private_key = (const unsigned char *)privateKey.bytes;

    unsigned char public_key_serialized[65];

    size_t public_key_length = 65;

    secp256k1_pubkey public_key;

    const secp256k1_context *ctx = secp256k1_context_create(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY);

    BOOL valid = ((int)secp256k1_ec_seckey_verify(ctx, private_key) == (int)1);

    printf("Private key is %s.\n", (valid ? "valid" : "not valid"));

    BOOL success = secp256k1_ec_pubkey_create(ctx, &public_key, private_key);

    printf("Public key %s created.\n", (success ? "successfully" : "could not be"));

    secp256k1_ec_pubkey_serialize(ctx, public_key_serialized, &public_key_length, &public_key, SECP256K1_EC_UNCOMPRESSED);

    NSData *publicKeyData = [[NSData dataWithBytes:public_key_serialized length:public_key_length] subdataWithRange:NSMakeRange(1, public_key_length - 1)];

    return publicKeyData;
}

- (NSString * _Nonnull)signMessage:(NSData * _Nonnull)message withKey:(NSData * _Nonnull)privateKey withHashing:(BOOL)withHashing {
    secp256k1_ecdsa_recoverable_signature signature;
    unsigned char signature_serialised[64];

    const unsigned char *msg = withHashing ? [message sha3:256].bytes : message.bytes;

    const unsigned char *private_key = privateKey.bytes;
    int recid = 0;
    const secp256k1_context *ctx = secp256k1_context_create(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY);

    secp256k1_ecdsa_sign_recoverable(ctx, &signature, msg, private_key, NULL, NULL);
    secp256k1_ecdsa_recoverable_signature_serialize_compact(ctx, signature_serialised, &recid, &signature);

    unsigned char signature_serialised_with_recid[65];
    for (int i = 0; i < 64; i++) {
        signature_serialised_with_recid[i] = signature_serialised[i];
    }
    signature_serialised_with_recid[64] = recid;

    NSData *signatureData = [NSData dataWithBytes:&signature_serialised_with_recid length:65];
    NSString *signatureString = [signatureData hexadecimalString];

    return signatureString;
}

- (NSData *)dataFromHexString:(NSString *) string {
    if([string length] % 2 == 1){
        string = [@"0"stringByAppendingString:string];
    }
    
    const char *chars = [string UTF8String];
    int i = 0, len = (int)[string length];
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
    
}

@end

@implementation NSData (Hex)

- (NSString * _Nonnull)hexadecimalString {
    const unsigned char *dataBuffer = (const unsigned char *)self.bytes;

    if (!dataBuffer) {
        return [NSString string];
    }

    NSUInteger dataLength = self.length;
    NSMutableString *hexString  = [NSMutableString string];

    for (int i = 0; i < dataLength; ++i) {
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }

    return [NSString stringWithString:hexString];
}

- (NSData * _Nonnull)sha3:(NSUInteger)digest {
    int byteCount = (int)(digest / 8);
    const char *input = self.bytes;
    int inputLength = (int)self.length;
    uint8_t output[byteCount];

    keccak((uint8_t *)input, inputLength, output, byteCount);

    return [NSData dataWithBytes:output length:byteCount];
}

@end
