--绝望色 西洋镜
function c65060012.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x6da3),2,99)
	--kaleidoscope
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,65060012)
	e1:SetTarget(c65060012.sptg)
	e1:SetOperation(c65060012.spop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetCondition(c65060012.effcon)
	e2:SetTarget(c65060012.efftg)
	e2:SetOperation(c65060012.effop)
	c:RegisterEffect(e2)
end

function c65060012.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()>0 and Duel.IsChainNegatable(ev)
end

function c65060012.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if c:GetMutualLinkedGroupCount()>=1 or Duel.GetFlagEffect(tp,65060031)~=0 then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	end
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) and (c:GetMutualLinkedGroupCount()>=2 or (c:GetMutualLinkedGroupCount()>=1 and Duel.GetFlagEffect(tp,65060031)~=0)) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end

function c65060012.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetMutualLinkedGroupCount()>=1 or Duel.GetFlagEffect(tp,65060031)~=0 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and (c:GetMutualLinkedGroupCount()>=2 or (c:GetMutualLinkedGroupCount()>=1 and Duel.GetFlagEffect(tp,65060031)~=0)) then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		end
	end
	if c:GetMutualLinkedGroupCount()>=3 or (c:GetMutualLinkedGroupCount()>=2 or (c:GetMutualLinkedGroupCount()>=2 and Duel.GetFlagEffect(tp,65060031)~=0)) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_REMOVED,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetValue(c65060012.aclimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			tc=g:GetNext()
		end
	end
end
function c65060012.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c65060012.spfil(c,e,tp)
   return c:IsCode(65060012) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end

function c65060012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function c65060012.spop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_EXTRA,0,nil)
	Duel.ConfirmCards(1-tp,cg)
	local gg=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_EXTRA,0,nil,65060012)
	if gg>0 then
		local tgg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA+LOCATION_ONFIELD,0,nil,65060012)
		Duel.SendtoGrave(tgg,REASON_EFFECT)
	end
end
