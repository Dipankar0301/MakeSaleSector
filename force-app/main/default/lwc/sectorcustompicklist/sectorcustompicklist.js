import LightningDatatable from 'lightning/datatable';
import customPicklist from './sectorcustompicklistcombobox.html';

export default class Sectorcustompicklist extends LightningDatatable {
    static customTypes = {
        SectorPicklistCustom : {
            template: customPicklist,
            standardCellLayout: true,
            typeAttributes: ['label', 'value','options','opplineid','columnstate']
        }
    }
}