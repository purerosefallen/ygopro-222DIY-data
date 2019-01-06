--龙逆术-警戒
function c65060026.initial_effect(c)
	aux.EnableDualAttribute(c)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(PHASE_BATTLE+PHASE_BATTLE_START,PHASE_BATTLE+PHASE_BATTLE_START)
	e1:SetCountLimit(1,65060026)
	e1:SetCondition(c65060026.spcon)
	e1:SetTarget(c65060026.sptg)
	e1:SetOperation(c65060026.spop)
	c:RegisterEffect(e1)
	--Dual
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.IsDualState)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(3100)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(aux.IsDualState)
	e3:SetTarget(c65060026.damtg)
	e3:SetOperation(c65060026.damop)
	c:RegisterEffect(e3)
end
function c65060026.atkfil(c,e)
	return (c:IsAttackable() and not c:IsImmuneToEffect(e)) or e:GetHandler():IsAttackable()
end
function c65060026.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c65060026.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9da4))
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetOwnerPlayer(tp)
	e2:SetValue(c65060026.efilter)
	Duel.RegisterEffect(e2,tp)
	local g=Duel.SelectMatchingCard(tp,c65060026.atkfil,tp,0,LOCATION_MZONE,1,1,nil,e)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local m=0
		if c:IsAttackable() then 
			m=Duel.CalculateDamage(c,tc) 
		else
			m=Duel.CalculateDamage(tc,c)
		end
		if m~=0 then
			Duel.BreakEffect()
			if not c:IsStatus(STATUS_BATTLE_DESTROYED) then Duel.SendtoHand(c,nil,REASON_EFFECT) end
		end
	end
end
function c65060026.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c65060026.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end
function c65060026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c65060026.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)and Duel.SelectYesNo(tp,aux.Stringid(65060026,0)) then
			Duel.BreakEffect()
			--indes
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9da4))
			e1:SetValue(1)
			Duel.RegisterEffect(e1,tp)
			c:RegisterFlagEffect(65060026,RESET_EVENT+RESETS_STANDARD,0,1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetRange(LOCATION_MZONE)
			e2:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EVENT_ADJUST)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetCondition(c65060026.thcon)
			e2:SetOperation(c65060026.thop)
			c:RegisterEffect(e2)	
		end
	end
end
function c65060026.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(65060026)~=0 
end
function c65060026.thop(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph==PHASE_MAIN2 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.Readjust()
	end
end
