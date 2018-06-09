--虚数魔域 贝尔
function c65010024.initial_effect(c)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65010024)
	e1:SetCondition(c65010024.spscon)
	e1:SetCost(c65010024.spscost)
	e1:SetTarget(c65010024.spstg)
	e1:SetOperation(c65010024.spsop)
	c:RegisterEffect(e1)
	--spsummon token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c65010024.lfcon)
	e2:SetTarget(c65010024.lftg)
	e2:SetOperation(c65010024.lfop)
	c:RegisterEffect(e2)
end

function c65010024.spsconfil(c)
	return not c:IsSetCard(0x3da0)
end

function c65010024.spscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c65010024.spsconfil,tp,LOCATION_MZONE,0,nil)==0 
end

function c65010024.spscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end

function c65010024.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end

function c65010024.spsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end

function c65010024.lfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end

function c65010024.lftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,65010023,0,0x4011,2500,2000,10,RACE_CYBERSE,ATTRIBUTE_LIGHT,POS_FACEUP,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c65010024.lfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65010023,0,0x4011,2500,2000,10,RACE_CYBERSE,ATTRIBUTE_LIGHT,POS_FACEUP,tp) then return end
	local token=Duel.CreateToken(tp,65010023)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	if Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_REMOVED,0,nil,0x3da0)>=2 then Duel.Draw(tp,1,REASON_EFFECT) end
end