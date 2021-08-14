/*
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

library StringArrayLib {
    using StringArrayLib for Values;
    struct Values {
        string[]  _items;
    }
    function pushValue(Values storage self, string memory element) internal returns (bool) {
        if (!exists(self, element)) {
            self._items.push(element);
            return true;
        }
        return false;
    }
    function removeValue(Values storage self, string memory element) internal returns (bool) {
        for (uint i = 0; i < self.size(); i++) {
            if ( compareTo(self._items[i], element)) {
                self._items[i] = self._items[self.size() - 1];
                self._items.pop();
                return true;
            }
        }
        return false;
    }
    function compareTo(string memory _base, string memory _value)
    internal
    pure
    returns (bool) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        if (_baseBytes.length != _valueBytes.length) {
            return false;
        }

        for (uint i = 0; i < _baseBytes.length; i++) {
            if (_baseBytes[i] != _valueBytes[i]) {
                return false;
            }
        }

        return true;
    }
    function size(Values storage self) internal view returns (uint256) {
        return self._items.length;
    }
    function exists(Values storage self, string memory element) internal view returns (bool) {
        for (uint i = 0; i < self.size(); i++) {
            if ( compareTo(self._items[i], element) ) {
                return true;
            }
        }
        return false;
    }
    function getAllValues(Values storage self) internal view returns(string[] memory) {
        return self._items;
    }

}
