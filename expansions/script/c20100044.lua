--御刀使的紧急任务
require("expansions/script/c20100002")
local m=20100044
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.eqcost)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)   
	--release replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_RELEASE_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)  
end
function cm.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.eqfilter(c)
	return c:IsSetCard(0xc90) and (c:GetEquipCount()==0) and c:IsFaceup()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct>2 then ct=2 end
	e:SetLabel(ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.eqfilter,tp,LOCATION_MZONE,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,g:GetCount(),tp,nil)
end
function cm.aeqfilter(c,e)
	return  c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and c:IsFaceup()
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<ct then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.aeqfilter,nil,e)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local code=tc:GetOriginalCode()
			Cirn9.TojiEquip(tc,(code+1),e,tp,eg,ep,ev,re,r,rp)   
			tc=g:GetNext()
		end
	end
end
function cm.repfilter(c,tp,re)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
		and c:IsSetCard(0xc91) and c:IsType(TYPE_EQUIP) and c:IsReason(REASON_COST) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp,re)
		and e:GetHandler():IsAbleToRemoveAsCost() and re:GetHandler():IsSetCard(0xc91) end
	return Duel.SelectYesNo(tp,aux.Stringid(m,0))
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer(),c:GetReasonEffect())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST+REASON_REPLACE)
end