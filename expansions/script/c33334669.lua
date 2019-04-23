--彩虹魔术魔女 虹采
function c33334669.initial_effect(c)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33334669)
	e1:SetCost(c33334669.cost)
	e1:SetTarget(c33334669.target)
	e1:SetOperation(c33334669.activate)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,33334660)
	e2:SetCost(c33334669.thcost)
	e2:SetTarget(c33334669.thtg)
	e2:SetOperation(c33334669.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(33334669,ACTIVITY_SPSUMMON,c33334669.counterfilter)
end
function c33334669.counterfilter(c)
	return c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c33334669.costfil(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToGraveAsCost()
end
function c33334669.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33334669.costfil,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():IsAbleToGraveAsCost() and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)<=1 and Duel.GetCustomActivityCount(33334669,tp,ACTIVITY_SPSUMMON)==0 end
	local g=Duel.SelectMatchingCard(tp,c33334669.costfil,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c33334669.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c33334669.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetSummonType()~=SUMMON_TYPE_RITUAL 
end
function c33334669.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetSummonLocation()==LOCATION_EXTRA and Duel.IsPlayerCanSendtoDeck(1-tp,c)
end
function c33334669.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33334669.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	local num=Duel.GetMatchingGroupCount(c33334669.filter,tp,0,LOCATION_MZONE,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,num,1-tp,LOCATION_MZONE)
end
function c33334669.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33334669.filter,tp,0,LOCATION_MZONE,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_RULE)
	end
end


function c33334669.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c33334669.spfil(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33334669.thfil(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c33334669.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local num1=Duel.GetMatchingGroupCount(c33334669.spfil,tp,LOCATION_REMOVED,0,nil,e,tp)
	local num2=Duel.GetMatchingGroupCount(c33334669.thfil,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return num1>0 and num2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33334669.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c33334669.spfil,tp,LOCATION_REMOVED,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c33334669.thfil,tp,LOCATION_REMOVED,0,nil)
	local num1=g1:GetCount()
	local num2=g2:GetCount()
	if num1>0 and num2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		if num1>Duel.GetLocationCount(tp,LOCATION_MZONE) then
			local num=Duel.GetLocationCount(tp,LOCATION_MZONE)
			g1=g1:FilterSelect(tp,aux.TRUE,num,num,nil)
		end
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end