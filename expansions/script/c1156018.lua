--三途河畔的摆渡人
function c1156018.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156018.lcheck,1)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c1156018.op2)
	c:RegisterEffect(e2)
--
end
--
function c1156018.lcheck(c)
	return c:IsLinkType(TYPE_SPIRIT)
end
--
function c1156018.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2_1:SetDescription(1104)
	e2_1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2_1:SetCode(EVENT_PHASE+PHASE_END)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetCountLimit(1)
	e2_1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e2_1:SetCondition(aux.SpiritReturnCondition)
	e2_1:SetTarget(c1156018.tg2_1)
	e2_1:SetOperation(c1156018.op2_1)
	c:RegisterEffect(e2_1)
	local e2_2=e2_1:Clone()
	e2_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2_2)
end
--
function c1156018.tfilter2_1(c,e,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c1156018.tg2_1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then return true
		else return e:GetHandler():IsAbleToHand()
			and Duel.IsExistingMatchingCard(c1156018.tfilter2_1,tp,0,LOCATION_DECK,1,nil,e,tp)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
--
function c1156018.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(c,nil,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c1156018.tfilter2_1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end
--
