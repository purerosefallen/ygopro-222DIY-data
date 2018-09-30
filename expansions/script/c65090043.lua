--星之骑士拟身 水泡
function c65090043.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090043)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_AQUA),1,true,true)
	--tograve and copy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c65090043.detg)
	e2:SetOperation(c65090043.deop)
	c:RegisterEffect(e2)
end
function c65090043.defil(c,e)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end

function c65090043.detg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65090043.defil(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c65090043.defil,tp,0,LOCATION_MZONE,1,nil,e) end
	local g=Duel.SelectTarget(tp,c65090043.defil,tp,0,LOCATION_MZONE,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end

function c65090043.deop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				local mc=g:GetFirst()
				local c=e:GetHandler()
				local code=tc:GetCode()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetCode(EFFECT_CHANGE_CODE)
				e1:SetValue(code)
				mc:RegisterEffect(e1)
				local cid=mc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
			end
		end
	end
end