--夜之晶月辉印
function c65020067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65020067.target)
	e1:SetOperation(c65020067.activate)
	c:RegisterEffect(e1)
end
function c65020067.thfil(c)
	return c:IsSetCard(0x9da3) and c:IsAbleToHand()
end
function c65020067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020067.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65020067,0,0x21,0,2000,4,RACE_WYRM,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65020067.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c65020067.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
	Duel.ConfirmCards(1-tp,g)
	Duel.BreakEffect()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,65020067,0,0x21,0,2000,4,RACE_WYRM,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c65020067.con)
	e1:SetCost(c65020067.cost)
	e1:SetTarget(c65020067.xyztg)
	e1:SetOperation(c65020067.xyzop)
	c:RegisterEffect(e1,true)
	Duel.SpecialSummonComplete()
	end
end
function c65020067.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c65020067.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(65020067)==0 end
	c:RegisterFlagEffect(65020067,RESET_CHAIN,0,1)
end
function c65020067.xyzfilter2(c,mg)
	return c:IsXyzSummonable(mg) and c:IsType(TYPE_XYZ)
end 

function c65020067.xyzfilter1(c,tp)
	return c:IsSetCard(0x9da3) and c:IsFaceup() and not c:IsType(TYPE_TOKEN) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c65020067.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		  local g=Duel.GetMatchingGroup(c65020067.xyzfilter1,tp,LOCATION_MZONE,0,nil,tp)
		  return Duel.IsExistingMatchingCard(c65020067.xyzfilter2,tp,LOCATION_EXTRA,0,1,nil,g) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c65020067.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65020067.xyzfilter1,tp,LOCATION_MZONE,0,nil,tp)
	if g:GetCount()<=0 then return end
	local xyzg=Duel.GetMatchingGroup(c65020067.xyzfilter2,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g,1,10)
	end
end