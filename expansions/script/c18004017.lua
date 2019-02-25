--性感手枪死神眼
if not pcall(function() require("expansions/script/c18004001") end) then require("script/c18004001") end
local m=18004017
local cm=_G["c"..m]
cm.rssetcode="SexGun"
function cm.initial_effect(c)
	rssg.SexGunCode(c)   
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkCode,18004005),2,99,cm.lcheck)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"des",nil,LOCATION_MZONE,nil,cm.cost,cm.tg,cm.op)
	local e2=rsef.SV_IMMUNE_EFFECT(c,rsval.imoe,cm.con2)
end
function cm.con2(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,6,nil,18004005)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,6) end
	Duel.DiscardDeck(tp,6,REASON_COST)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsCode,nil,18004005)
	e:SetLabel(ct)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	if #dg>0 then
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
