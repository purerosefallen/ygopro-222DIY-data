--冥暗蜘蛛
function c65080051.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65080051,1))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c65080051.ntcon)
	e1:SetOperation(c65080051.ntop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,65080051)
	e2:SetCondition(c65080051.con)
	e2:SetTarget(c65080051.tg)
	e2:SetOperation(c65080051.op)
	c:RegisterEffect(e2)
end
function c65080051.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 
end

function c65080051.filter(c,e,tp,spchk)
	return c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_INSECT) and (c:IsAbleToHand() or (spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1))
end
function c65080051.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local gn=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_DEFENSE)
	local spchk=gn:GetCount()>0 
	if chk==0 then return Duel.IsExistingMatchingCard(c65080051.filter,tp,LOCATION_DECK,0,1,nil,e,tp,spchk) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65080051.op(e,tp,eg,ep,ev,re,r,rp)
	local gn=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_FACEUP_DEFENSE)
	local spchk=gn:GetCount()>0
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c65080051.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,spchk)
			local tc=g:GetFirst()
			if tc and spchk and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(65080051,0))) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			else
				Duel.SendtoHand(tc,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65080051.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c65080051.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_INSECT 
end



function c65080051.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c65080051.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(2)
	c:RegisterEffect(e1)
end