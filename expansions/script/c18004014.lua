--性感手枪全弹连发
if not pcall(function() require("expansions/script/c18004001") end) then require("script/c18004001") end
local m=18004014
local cm=_G["c"..m]
cm.rssetcode="SexGun"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,18004005),2,99)
	c:EnableReviveLimit()  
	rssg.SexGunCode(c)   
	local e1=rsef.STF(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"rm",nil,rscon.sumtype("syn"),nil,cm.tg,cm.op)
	local e2=rsef.SV_IMMUNE_EFFECT(c,rsval.imoe,cm.con2)
end
function cm.con2(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,6,nil,18004005)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetMaterialCount()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
	e:SetLabel(ct)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
