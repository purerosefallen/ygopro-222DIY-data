--Vessel of Sin 露西菲尼亚的四面镜
function c77707701.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,77707701+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c77707701.cost)
	e1:SetTarget(c77707701.target)
	e1:SetOperation(c77707701.operation)
	c:RegisterEffect(e1)
end
function c77707701.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c77707701.rmfilter(c)
	return c:IsAbleToRemove()
end
function c77707701.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c77707701.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77707701.rmfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c77707701.rmfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77707701.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end  
local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c77707701.aclimit)
	e1:SetLabel(tc:GetCode())
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetLabel(tc:GetFieldID())
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
end
function c77707701.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:GetOriginalCode()==e:GetLabel() and (not rc:IsOnField() or rc:GetFieldID()~=e:GetLabelObject():GetLabel())
end