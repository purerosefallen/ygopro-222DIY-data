--伐木者
function c65071032.initial_effect(c)
	--tograve and copy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65071032+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c65071032.detg)
	e2:SetOperation(c65071032.deop)
	c:RegisterEffect(e2)
end
function c65071032.defil(c,e)
	return c:IsType(TYPE_EFFECT)
end

function c65071032.detg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65071032.defil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65071032.defil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) end
	local g=Duel.SelectTarget(tp,c65071032.defil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end

function c65071032.deop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			if g:GetCount()>0 then
				local mc=g:GetFirst()
				local c=e:GetHandler()
				local code=tc:GetCode()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e1:SetCode(EFFECT_CHANGE_CODE)
				e1:SetValue(code)
				mc:RegisterEffect(e1)
				local cid=mc:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(65071032,0))
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2:SetCountLimit(1)
				e2:SetRange(LOCATION_MZONE)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e2:SetLabelObject(e1)
				e2:SetLabel(cid)
				e2:SetOperation(c65071032.rstop)
				mc:RegisterEffect(e2)
			end
		end
	end
end
function c65071032.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end