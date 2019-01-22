--小黄
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=12030008
local cm=_G["c"..m]
cm.rssetcode="yatori"
function c12030008.initial_effect(c)
	--negate effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12030008,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12030008.condition)
	e1:SetTarget(c12030008.target)
	e1:SetOperation(c12030008.operation)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12030008,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c12030008.distg)
	e2:SetOperation(c12030008.disop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12030008,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c12030008.drcon)
	e3:SetTarget(c12030008.drtg)
	e3:SetOperation(c12030008.drop)
	c:RegisterEffect(e3)
end
function c12030008.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ( Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil) or Duel.GetTurnPlayer()==tp ) and re:GetHandler():GetLocation()==LOCATION_GRAVE
end
function c12030008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c12030008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	   local e6=Effect.CreateEffect(c)
	   e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	   e6:SetCode(EVENT_CHAIN_SOLVING)
	   e6:SetReset(RESET_CHAIN)
	   e6:SetOperation(c12030008.disop1)
	   Duel.RegisterEffect(e6,tp)
	end
end
function c12030008.disop1(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():GetLocation()==LOCATION_GRAVE
	 then
		Duel.NegateEffect(ev)
	end
end
function c12030008.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local dm=Duel.GetLP(tp)/2
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,1,tp,dm)
end
function c12030008.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dm=Duel.GetLP(tp)/2
	if dm>0 then
	Duel.Damage(tp,dm,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(dm)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e1)
   end
end
function c12030008.drcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c12030008.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12030008.cfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
	if  rp==1-tp and tp==e:GetLabel() then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,nil)
	else
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,2)
	end
end
function c12030008.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c12030008.cfilter),tp,0,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,tp,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	end
	local ss=Duel.GetMatchingGroup(nil,tp,0,LOCATION_GRAVE,nil)
	if  rp==1-tp and tp==e:GetLabel() then
	   Duel.Remove(ss,POS_FACEDOWN,REASON_EFFECT)
	else
	   Duel.SendtoDeck(ss,tp,2,REASON_EFFECT)
	end
end