--梦之镇的路标
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400007.initial_effect(c)
	--summon limit
	yume.AddYumeSummonLimit(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,71400007)
	e1:SetTarget(c71400007.target)
	e1:SetOperation(c71400007.operation)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	--gy banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,71400007)
	e2:SetCost(c71400007.cost)
	e2:SetTarget(c71400007.target)
	e2:SetOperation(c71400007.operation)
	c:RegisterEffect(e2)
end
function c71400007.filter(c,e,tp,zone)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c71400007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c71400007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=Duel.GetLinkedZone(tp)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c71400007.filter(chkc,e,tp,zone) end
	if chk==0 then return zone~=0
		and Duel.IsExistingTarget(c71400007.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectTarget(tp,c71400007.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
end
function c71400007.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end