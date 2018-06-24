--白笛 不动如山之奥森
function c33330017.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x556),4,3)
	c:EnableReviveLimit() 
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(c33330017.indesval)
	e4:SetCondition(c33330017.con)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetCondition(c33330017.con)
	e1:SetValue(c33330017.atkval)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13893596,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetTarget(c33330017.ctg)
	e2:SetOperation(c33330017.cop)
	c:RegisterEffect(e2)
	--des
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetOperation(c33330017.desop)
	c:RegisterEffect(e5)
end
function c33330017.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetCounter(0x1009)>=3 then
	   Duel.Hint(HINT_CARD,0,33330017)
	   Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c33330017.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x1019,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c33330017.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c and c:IsFaceup() and c:IsRelateToEffect(e) and c:IsCanAddCounter(0x1009,1) then
	   c:AddCounter(0x1019,1)
	   local g=Duel.GetMatchingGroup(c33330017.adfilter,tp,0,LOCATION_MZONE,nil)
	   if g:GetCount()>0 then
		  for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(-300)
			tc:RegisterEffect(e1)
		  end
	   end
	end
end
function c33330017.adfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c33330017.atkval(e)
	return e:GetHandler():GetOverlayCount()-1
end
function c33330017.indesval(e,re,rp)
	return re:GetHandler()~=e:GetHandler()
end
function c33330017.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,33330004)
end