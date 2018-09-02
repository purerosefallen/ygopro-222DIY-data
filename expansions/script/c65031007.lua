--单纯的温柔律歌
function c65031007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65031007,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c65031007.condition)
	e1:SetTarget(c65031007.target)
	e1:SetOperation(c65031007.activate)
	c:RegisterEffect(e1)
	--activate2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c65031007.condition2)
	e2:SetTarget(c65031007.target2)
	e2:SetOperation(c65031007.activate2)
	c:RegisterEffect(e2)
end
function c65031007.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetMatchingGroupCount(c65031007.cfilter,tp,LOCATION_MZONE,0,nil)==0 
end
function c65031007.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg:IsOnField() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,65031002,0,0x4011,1500,1500,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP,tp) end
end
function c65031007.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc and Duel.NegateAttack() then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,65031002,0,0x4011,1500,1500,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP,tp) then
			local token=Duel.CreateToken(tp,65031008)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			--cannot summon
			local e1=Effect.CreateEffect(token)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c65031007.splimit)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SUMMON)
			token:RegisterEffect(e2,true)
			--set
			local e3=Effect.CreateEffect(token)
			e3:SetCategory(CATEGORY_TOGRAVE)
			e3:SetType(EFFECT_TYPE_IGNITION)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCountLimit(1)
			e3:SetCost(c65031007.tgcost)
			e3:SetTarget(c65031007.tgtg)
			e3:SetOperation(c65031007.tgop)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e3,true)
			--effect type
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetValue(TYPE_EFFECT)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e4,true)
			token:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65031007,2))
			Duel.SpecialSummonComplete()
		end
	end
end


function c65031007.cfilter(c)
	return not c:IsCode(65031002) 
end
function c65031007.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE) and Duel.IsChainNegatable(ev) and ep~=tp and Duel.GetMatchingGroupCount(c65031007.cfilter,tp,LOCATION_MZONE,0,nil)==0 
end
function c65031007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,65031002,0,0x4011,1500,1500,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP,tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c65031007.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		if Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)~=0 and ec:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,65031002,0,0x4011,1500,1500,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP,tp) then
			local token=Duel.CreateToken(tp,65031008)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) 
			--cannot summon
			local e1=Effect.CreateEffect(token)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c65031007.splimit)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SUMMON)
			token:RegisterEffect(e2,true)
			--tograve
			local e3=Effect.CreateEffect(token)
			e3:SetCategory(CATEGORY_TOGRAVE)
			e3:SetType(EFFECT_TYPE_IGNITION)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCountLimit(1)
			e3:SetCost(c65031007.tgcost)
			e3:SetTarget(c65031007.tgtg)
			e3:SetOperation(c65031007.tgop)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e3,true)
			--effect type
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetValue(TYPE_EFFECT)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e4,true)
			token:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65031007,2))
			Duel.SpecialSummonComplete()
		end
	end
end
function c65031007.splimit(e,c)
	return not c:IsCode(65031002)
end

function c65031007.costfil(c)
	return c:IsSetCard(0xada1) and (c:IsFacedown() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost()
end
function c65031007.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65031011.costfil,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65031011.costfil,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c65031007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,0)
end
function c65031007.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end