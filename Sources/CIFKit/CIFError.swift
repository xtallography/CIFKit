//
//  CIFError.swift
//

import CCIF
import CCIF.Shims
import Foundation

/// A Swift enumeration wrapping `cif_api`'s function return codes.
/// These codes may be thrown as `Error`s, with the exception of `.ok` and
/// the `.noSuch*` case family.
///
/// - Note: Documentation as well as notes on individual cases are reproduced from the official CIF API documentation. The CIF API is distributed under the terms of the GNU Lesser General Public License.
/// - SeeAlso: [Official `cif_api` Documentation](http://comcifs.github.io/cif_api/group__return__codes.html)
public enum CIFAPIReturnCode: Int32 {
    /// (`CIF_OK`) A result code indicating successful completion of the requested operation.
    case ok = 0

    /// (`CIF_FINISHED`) A result code indicating that the requested operation completed successfully, but subsequent repetitions of the same operation can be expected to fail.
    /// - Note: This code is used mainly by packet iterators to signal the user when the last available packet is returned.
    case finished = 1

    /// (`CIF_ERROR`) A result code indicating that the requested operation failed because an error occurred in one of the underlying libraries.
    /// - Note: This is CIF API's general-purpose error code for faults that it cannot more specifically diagnose. Pretty much any API function can return this code under some set of circumstances. Failed memory allocations or unexpected errors emitted by the storage back end are typical triggers for this code. In the event that this code is returned, the C library's global errno variable may indicate the nature of the error more specifically.
    case error = 2

    /// (`CIF_MEMORY_ERROR`) A result code indicating that the requested operation could not be performed because of a dynamic memory allocation failure.
    case memoryError = 3

    /// (`CIF_INVALID_HANDLE`) A result code returned on a best-effort basis to indicate that a user-provided object handle is invalid.
    /// - Note: The CIF API does not guarantee to be able to recognize invalid handles. If an invalid handle is provided then a CIF_ERROR code may be returned instead, or really anything might happen -- generally speaking, library behavior is undefined in these cases. Where it does detect invalidity, that result may be context dependent. That is, the handle may be invalid for the use for which it presented, but valid for different uses. In particular, this may be the case if a save frame handle is presented to one of the functions that requires specifically a data block handle.
    case invalidHandle = 4

    /// (`CIF_INTERNAL_ERROR`) A result code indicating that an internal error or inconsistency was encountered.
    /// - Note: If this code is emitted then it means a bug in the library has been triggered (if for no other reason than that this is the wrong code to return if an internal bug has not been triggered).
    case internalError = 5

    /// (`CIF_ARGUMENT_ERROR`) A result code indicating that an internal error or inconsistency was encountered.
    /// - Note: This is a fallback code -- a more specific code will be emitted when one is available.
    case argumentError = 6

    /// (`CIF_MISUSE`) A result code indicating that although the function was called with with substantially valid arguments, the context or conditions do not allow the call.
    case misuse = 7

    /// (`CIF_NOT_SUPPORTED`) A result code indicating that an optional feature was invoked and the library implementation in use does not support it.
    case notSupported = 8

    /// (`CIF_ENVIRONMENT_ERROR`) A result code indicating that the operating environment is missing data or features required to complete the operation.
    /// - Note: For example, the `cif_create()` function of an SQLite-based implementation that depends on foreign keys might emit this code if it determines that the external sqlite library against which it is running omits foreign key support.
    case environmentError = 9

    /// (`CIF_CLIENT_ERROR`) A result code indicating a synthetic error injected by client code via a callback function.
    case clientError = 10

    /// (`CIF_DUP_BLOCKCODE`) A result code signaling an attempt to cause a CIF to contain blocks with duplicate (by CIF's criteria) block codes.
    case duplicateBlockCode = 11

    /// (`CIF_INVALID_BLOCKCODE`) A result code signaling an attempt to cause a CIF to contain a block with an invalid block code.
    case invalidBlockCode = 12

    /// (`CIF_NOSUCH_BLOCK`) A result code signaling an attempt to retrieve a data block from a CIF (by reference to its block code) when that CIF does not contain a block bearing that code.
    case noSuchBlock = 13

    /// (`CIF_DUP_FRAMECODE`) A result code signaling an attempt to cause a data block to contain save frames with duplicate (by CIF's criteria) frame codes.
    case duplicateFrameCode = 21

    /// (`CIF_INVALID_FRAMECODE`) A result code signaling an attempt to cause a data block to contain a save frame with an invalid frame code.
    case invalidFrameCode = 22

    /// (`CIF_NOSUCH_FRAME`) A result code signaling an attempt to retrieve a save frame from a data block (by reference to its frame code) when that block does not contain a frame bearing that code.
    case noSuchFrame = 23

    /// (`CIF_CAT_NOT_UNIQUE`) A result code signaling an attempt to retrieve a loop from a save frame or data block by category, when there is more than one loop tagged with the specified category.
    case categoryNotUnique = 31

    /// (`CIF_INVALID_CATEGORY`) A result code signaling an attempt to retrieve a loop from a save frame or data block by category, when the requested category is invalid.
    /// - Note: The main invalid category is NULL (as opposed to the empty category name), which is invalid only for retrieval, not loop creation.
    case invalidCategory = 32

    /// (`CIF_NOSUCH_LOOP`) A result code signaling an attempt to retrieve a loop from a save frame or data block by category, when the container does not contain any loop tagged with the specified category.
    case noSuchLoop = 33

    /// (`CIF_RESERVED_LOOP`) A result code signaling an attempt to manipulate a loop having special significance to the library, in a manner that is not allowed.
    case reservedLoop = 34

    /// (`CIF_WRONG_LOOP`) A result code indicating that an attempt was made to add an item value to a different loop than the one containing the item.
    case wrongLoop = 35

    /// (`CIF_EMPTY_LOOP`) A result code indicating that a packet iterator was requested for a loop that contains no packets, or that a packet-less loop was encountered during parsing.
    case emptyLoop = 36

    /// (`CIF_NULL_LOOP`) A result code indicating that an attempt was made to create a loop devoid of any data names.
    case nullLoop = 37

    /// (`CIF_DUP_ITEMNAME`) A result code indicating that an attempt was made to add an item to a data block or save frame that already contains an item of the same data name.
    /// - Note: "Same" in this sense is judged with the use of Unicode normalization and case folding.
    case duplicateItemName = 41

    /// (`CIF_INVALID_ITEMNAME`) A result code indicating that an attempt was made to add an item with an invalid data name to a CIF.
    /// - Note: Note that attempts to retrieve items by invalid name, on the other hand, simply return CIF_NOSUCH_ITEM
    case invalidItemName = 42

    /// (`CIF_NOSUCH_ITEM`) A result code indicating that an attempt to retrieve an item by name failed as a result of no item bearing that data name being present in the target container.
    case noSuchItem = 43

    /// (`CIF_AMBIGUOUS_ITEM`) A result code indicating that an attempt to retrieve a presumed scalar has instead returned one of multiple values found.
    case ambiguousItem = 44

    /// (`CIF_INVALID_PACKET`) A result code indicating that the requested operation could not be performed because a packet object provided by the user was invalid.
    /// - Note: For example, the packet might have been empty in a context where that is not allowed.
    case invalidPacket = 52

    /// (`CIF_PARTIAL_PACKET`) A result code indicating that during parsing, the last packet in a loop construct contained fewer values than the associated loop header had data names.
    case partialPacket = 53

    /// (`CIF_DISALLOWED_VALUE`) A result code indicating that an attempt was made to parse or write a value in a context that allows only values of kinds different from the given value's.
    /// - Note: The only context in CIF 2.0 that allows values of some kinds but not others is table indices. For this purpose, "allowed" is defined in terms of CIF syntax, ignoring any other considerations such as validity with respect to a data dictionary.
    case disallowedValue = 62

    /// (`CIF_INVALID_NUMBER`) A result code indicating that a string provided by the user could not be parsed as a number.
    /// - Note: "Number" here should be interpreted in the CIF sense: an optionally-signed integer or floating-point number in decimal format, with optional signed exponent and optional standard uncertainty.
    case invalidNumber = 72

    /// (`CIF_INVALID_INDEX`) A result code indicating that a (Unicode) string provided by the user as a table index is not valid for that use.
    case invalidIndex = 73

    /// (`CIF_INVALID_BARE_VALUE`) A result code indicating that a bare value encountered while parsing CIF starts with a character that is not allowed for that purpose.
    /// Note: This error is recognized where the start character does not cause the "value" to be interpreted as something else altogether, such as a data name or a comment. In CIF 2.0 parsing mode, only the dollar sign (as the first character of something that could be a value) will trigger this error; in CIF 1.1 mode, the opening and closing square brackets will also trigger it.
    case invalidBareValue = 74

    /// (`CIF_INVALID_CHAR`) A result code indicating that an invalid code sequence has been detected during I/O: a source character representation is not a valid code sequence in the encoding with which it is being interpreted.
    /// - Note: This includes those code sequences ICU describes as "illegal" as well as those it describes as "irregular".
    case invalidChar = 102

    /// (`CIF_UNMAPPED_CHAR`) A result code indicating that I/O fidelity cannot be maintained on account of there being no representation for a source character in the target form.
    case unmappedChar = 103

    /// (`CIF_DISALLOWED_CHAR`) A result code indicating that a well-formed code sequence encountered during I/O decodes to a character that is not allowed to appear in CIF.
    case disallowedChar = 104

    /// (`CIF_MISSING_SPACE`) A result code indicating that required whitespace was missing during CIF parsing.
    /// - Note: Recovery generally involves assuming the missing whitespace, which is fine as long as the reason for the error is not some previous, unobserved error such as an omitted opening table delimiter.
    case missingSpace = 105

    /// (`CIF_MISSING_ENDQUOTE`) A result code indicating that an in-line quoted string started on the current line but was not closed before the end of the line.
    case missingEndQuote = 106

    /// (`CIF_UNCLOSED_TEXT`) A result code indicating that a text field or triple-quoted string remained open when the end of the input was reached.
    case unclosedText = 107

    /// (`CIF_OVERLENGTH_LINE`) A result code indicating that input or output exceeded the relevant line-length limit.
    case overlengthLine = 108

    /// (`CIF_DISALLOWED_INITIAL_CHAR`) A result code indicating that a well-formed code sequence encountered at the beginning of CIF I/O decodes to a character that is not allowed to appear as the initial character of a CIF.
    /// - Note: At the point where this error is encountered, it may not yet be known which version of CIF is being parsed. The normal recovery path is to leave the character alone, likely allowing it to trigger a different, more specific error later.
    case disallowedInitialChar = 109

    /// (`CIF_WRONG_ENCODING`) A result code indicating that input is being parsed according to CIF-2 syntax, but being decoded according to a different encoding form than UTF-8.
    case wrongEncoding = 110

    /// (`CIF_NO_BLOCK_HEADER`) A result code indicating that during CIF parsing, something other than whitespace was encountered before the first block header.
    case noBlockHeader = 113

    /// (`CIF_FRAME_NOT_ALLOWED`) A result code indicating that during CIF parsing, a save frame header was encountered but save frame support was disabled.
    case frameNotAllowed = 122

    /// (`CIF_NO_FRAME_TERM`) A result code indicating that during CIF parsing, a data block header or save frame header was encountered while a save frame was being parsed, thus indicating that a save frame terminator must have been omitted.
    case noFrameTerminator = 123

    /// (`CIF_UNEXPECTED_TERM`) A result code indicating that during CIF parsing, a save frame terminator was encountered while no save frame was being parsed.
    case unexpectedTerm = 124

    /// (`CIF_EOF_IN_FRAME`) A result code indicating that during CIF parsing, the end of input was encountered while parsing a save frame.
    /// - Note: This can indicate that the input was truncated or that the frame terminator was omitted.
    case eofInFrame = 126

    /// (`CIF_RESERVED_WORD`) A result code indicating that an unquoted reserved word was encountered during CIF parsing.
    case reservedWord = 132

    /// (`CIF_MISSING_VALUE`) A result code indicating that during CIF parsing, no data value was encountered where one was expected.
    case missingValue = 133

    /// (`CIF_UNEXPECTED_VALUE`) A result code indicating that during CIF parsing, a data value was encountered where one was not expected.
    case unexpectedValue = 144

    /// (`CIF_UNEXPECTED_DELIM`) A result code indicating that during CIF parsing, a closing list or table delimiter was encountered outside the scope of any value.
    case unexpectedDelimiter = 135

    /// (`CIF_MISSING_DELIM`) A result code indicating that during CIF parsing, a putative list or table value was encountered without a closing delimiter.
    /// - Note: Alternatively, it is also conceivable that the previously-parsed opening delimiter was meant to be part of a value, but was not so interpreted on account of the value being unquoted.
    case missingDelimiter = 136

    /// (`CIF_MISSING_KEY`) A result code indicating that during parsing of a table value, an entry with no key was encountered.
    /// - Note: Note that "no key" is different from "zero-length key" or "blank key"; the latter two are permitted.
    case missingKey = 137

    /// (`CIF_UNQUOTED_KEY`) A result code indicating that during parsing of a table value, an unquoted key was encountered.
    case unquotedKey = 138

    /// (`CIF_MISQUOTED_KEY`) A result code indicating that during parsing of a table value, text block was encountered as a table key.
    /// - Note: The parser can handle that case just fine, but it is not allowed by the CIF 2.0 specifications.
    case misquotedKey = 139

    /// (`CIF_NULL_KEY`) A result code indicating that during parsing of a table value, colon-delimited key/value "pair" was encountered with no key at all (just colon, value).
    case nullKey = 140

    static var maxRawValue: Int = Int(cif_nerr)
}

extension CIFAPIReturnCode: Error {
    public var localizedDescription: String {
        return String(cString: cif_error_description(Int32(rawValue)))
    }
}

extension Int32 {
    var retCode: CIFAPIReturnCode {
        return CIFAPIReturnCode(rawValue: self) ?? .error
    }
}

public enum CIFTraverseReturnCode: Int {
    /// (`CIF_TRAVERSE_CONTINUE`) A return code for CIF-handler functions that indicates CIF traversal should continue along its normal path; has the same value as CIF_OK.
    case persist = 0

    /// (`CIF_TRAVERSE_SKIP_CURRENT`) A return code for CIF-handler functions that indicates CIF traversal should bypass the current element, or at least any untraversed children, and thereafter proceed along the normal path.
    case skip = -1

    /// (`CIF_TRAVERSE_SKIP_SIBLINGS`) A return code for CIF-handler functions that indicates CIF traversal should bypass the current element, or at least any untraversed children, and any untraversed siblings, and thereafter proceed along the normal path.
    case skipSiblings = -2

    /// (`CIF_TRAVERSE_END`) A return code for CIF-handler functions that indicates CIF traversal should stop immediately.
    case end = -3
}
