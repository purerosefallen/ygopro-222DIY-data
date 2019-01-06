--幻想之大妖精 艾尔希萝娅
function c65080044.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,c65080044.matfilter,3,2,nil,nil)
	c:EnableReviveLimit()
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c65080044.cost)
	e2:SetOperation(c65080044.operation)
	c:RegisterEffect(e2)
end
function c65080044.matfilter(c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c65080044.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and not c:IsPublic()
end
function c65080044.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65080044.cfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c65080044.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.ShuffleHand(tp)
end
function c65080044.operation(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.SelectOption(tp,aux.Stringid(65080044,0),aux.Stringid(65080044,1))
	if m==0 then
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65080044,0))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,1)
	e1:SetLabel(e:GetLabel()+1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e1:SetTarget(c65080044.tg)
	Duel.RegisterEffect(e1,tp)
	elseif m==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65080044,1))
		local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,1)
	e2:SetLabel(e:GetLabel()+1)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e2:SetValue(c65080044.val)
	Duel.RegisterEffect(e2,tp)
	end
end
function c65080044.tg(e,c)
	return c:IsLevelAbove(e:GetLabel()) or c:IsRankAbove(e:GetLabel())
end
function c65080044.val(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and (re:GetHandler():IsLevelAbove(e:GetLabel()) or re:GetHandler():IsRankAbove(e:GetLabel())) and not re:GetHandler():IsImmuneToEffect(e)
end