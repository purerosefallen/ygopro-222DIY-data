--唤灵质源 奥尔库
function c65050001.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65050001.spcon)
	e1:SetTarget(c65050001.sptg)
	e1:SetOperation(c65050001.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c65050001.thcost)
	e2:SetTarget(c65050001.thtg)
	e2:SetOperation(c65050001.thop)
	c:RegisterEffect(e2)
end
function c65050001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_TOKEN) end
	local lv=0
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,99,nil,TYPE_TOKEN)
	local rc=g:GetFirst()
	while rc do
		lv=lv+rc:GetLevel()
		rc=g:GetNext()
	end
	Duel.Release(g,REASON_COST)
	e:SetLabel(lv)
end
function c65050001.thfil(c,lv)
	return c:IsType(TYPE_RITUAL) and c:IsLevelBelow(lv) and c:IsAbleToHand()
end
function c65050001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN)
	local rc=rg:GetFirst()
	local lv=0
	while rc do
		lv=lv+rc:GetLevel()
		rc=rg:GetNext()
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c65050001.thfil,tp,LOCATION_DECK,0,1,nil,lv) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c65050001.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65050001.thfil,tp,LOCATION_DECK,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65050001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050001.spcofil,1,nil) and eg:GetCount()==1 
end
function c65050001.spcofil(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c65050001.filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,c:GetLevel(),RACE_SPELLCASTER,ATTRIBUTE_LIGHT)
end
function c65050001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=eg:GetFirst()
	if chkc then return Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,tc:GetLevel(),RACE_SPELLCASTER,ATTRIBUTE_LIGHT) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65050001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,tc:GetLevel(),RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,65050012)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(tc:GetLevel())
	e1:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c65050001.sumlimit)
	Duel.RegisterEffect(e2,tp)
end
function c65050001.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end