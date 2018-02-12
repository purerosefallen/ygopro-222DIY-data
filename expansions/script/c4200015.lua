--link3
function c4200015.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c4200015.lkcheck,2,3,c4200015.lcheck)
	c:EnableReviveLimit()
    --reverse card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4200015,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c4200015.restg)
	e1:SetOperation(c4200015.resop)
	c:RegisterEffect(e1)	
	--spirit return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c4200015.retreg)
	c:RegisterEffect(e3)
end
function c4200015.lkcheck(c)
	return c:IsType(TYPE_MONSTER) and (c:IsType(TYPE_UNION) or c:IsType(TYPE_SPIRIT)) 
end
function c4200015.lcheck(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount() 
end
function c4200015.restg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c4200015.resop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function c4200015.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(aux.SpiritReturnCondition)
	e1:SetTarget(c4200015.rettg)
	e1:SetOperation(c4200015.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function c4200015.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,4200010,0,0x4611,0,0,3,RACE_MACHINE,ATTRIBUTE_LIGHT)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c4200015.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,4200010,0,0x4611,0,0,3,RACE_MACHINE,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,4200010)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end