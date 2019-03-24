--露文律的将军 磬
function c21400040.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--toextra
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(21400040,0))
	e0:SetCategory(CATEGORY_TOEXTRA)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1)
	e0:SetTarget(c21400040.tetg)
	e0:SetOperation(c21400040.teop)
	c:RegisterEffect(e0)


	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)

	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400040,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c21400040.cost)
	e2:SetTarget(c21400040.target)
	e2:SetOperation(c21400040.op)
	c:RegisterEffect(e2)
	
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21400040,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCost(c21400040.thcost)
	e3:SetTarget(c21400040.thtg)
	e3:SetOperation(c21400040.thop)
	c:RegisterEffect(e3)

end


function c21400040.tefilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsRace(RACE_DRAGON)
end

function c21400040.tetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and chkc:IsControler(tp) and c21400040.tefilter(chkc) end

	if chk==0 then return Duel.IsExistingTarget(c21400040.tefilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  and Duel.IsPlayerCanSpecialSummonMonster(tp,21499999,0xc21,0x4011,0,0,3,RACE_DRAGON,ATTRIBUTE_WATER) end
--  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21400040,1))

	local g=Duel.SelectTarget(tp,c21400040.tefilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,99,nil)

	local cnt=g:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,cnt,0,0)
	local cntfg=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	if cntfg>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,cntfg,0,0)
	end
end

function c21400040.atkfl(c)
	return c:GetAttack()>=0
end
function c21400040.deffl(c)
	return c:GetDefense()>=0
end

function c21400040.teop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local cntrn=Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	if cntrn<=0 then return end
	

	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,21499999,0xc21,0x4011,0,0,3,RACE_DRAGON,ATTRIBUTE_WATER) then return end

	local atkn=g:Filter(c21400040.atkfl,nil):GetSum(Card.GetAttack)
	local defn=g:Filter(c21400040.deffl,nil):GetSum(Card.GetDefense)


	local token=Duel.CreateToken(tp,21499999)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atkn)
		token:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(defn)
		token:RegisterEffect(e2,true)   
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e4:SetValue(1)
		token:RegisterEffect(e4)   
	end
	Duel.SpecialSummonComplete()

end

function c21400040.filter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_PENDULUM)
end

function c21400040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400040.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21400040.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c21400040.tfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function c21400040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400040.tfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c21400040.tfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c21400040.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400040.tfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

function c21400040.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_DECK or c:GetSummonLocation()~= LOCATION_GRAVE
end

function c21400040.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(c21400040,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c21400040.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c21400040.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_GRAVE) 
end

function c21400040.thfilter(c)
	return c:IsAbleToGrave()
end
function c21400040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400040.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c21400040.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21400040.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
	end
end
