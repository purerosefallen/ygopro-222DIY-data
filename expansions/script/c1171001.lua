--诺札利亚 辉琉里
local m=1171001
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_NozaLeah=true
--
function c1171001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1171001)
	e1:SetTarget(c1171001.tg1)
	e1:SetOperation(c1171001.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1171001,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c1171001.con2)
	e2:SetCost(c1171001.cost2)
	e2:SetTarget(c1171001.tg2)
	e2:SetOperation(c1171001.op2)
	c:RegisterEffect(e2)
--
end
--
function c1171001.tfilter1(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSummonPlayer()~=tp
		and c:GetSummonLocation()~=LOCATION_EXTRA 
end
function c1171001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c1171001.tfilter1,1,nil,tp)
		and Duel.GetMZoneCount(1-tp)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
--
function c1171001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetCount()<1 then return end
	if Duel.Destroy(eg,REASON_EFFECT)<1 then return end
	if Duel.GetMZoneCount(1-tp)>0 then
		Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
--
function c1171001.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return bit.band(rc:GetOriginalType(),TYPE_MONSTER)~=0 and rp==tp
end
--
function c1171001.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(1171001)<1 end
	c:RegisterFlagEffect(1171001,RESET_CHAIN,0,1)
end
--
function c1171001.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
--
function c1171001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
--
