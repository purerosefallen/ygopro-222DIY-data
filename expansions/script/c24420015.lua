--羁绊礼装-童子切安纲
function c24420015.initial_effect(c)
			--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24420015,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c24420015.target)
	e1:SetOperation(c24420015.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c24420015.eqlimit)
	c:RegisterEffect(e4)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24420015,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c24420015.thcost)
	e2:SetTarget(c24420015.thtg)
	e2:SetOperation(c24420015.thop)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c24420015.actcon)
	e3:SetValue(c24420015.actlimit)
	c:RegisterEffect(e3)
	--chain attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(24420015,2))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(4)
	e5:SetCondition(c24420015.cacon)
	e5:SetTarget(c24420015.catg)
	e5:SetOperation(c24420015.caop)
	c:RegisterEffect(e5)
	if not c24420015.global_check then
		c24420015.global_check=true
		c24420015[0]=0
		c24420015[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c24420015.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c24420015.clear)
		Duel.RegisterEffect(ge2,0)
		end
	
end

function c24420015.eqlimit(e,c)
	return c:IsCode(24420014)
end
function c24420015.filter(c)
	return c:IsFaceup() and c:IsCode(24420014)
end
function c24420015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c24420015.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24420015.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c24420015.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c24420015.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c24420015.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c24420015.thfilter(c)
	return c:IsCode(24420014) and c:IsAbleToHand()
end
function c24420015.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c24420015.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c24420015.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c24420015.thfilter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

function c24420015.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==e:GetHandler():GetControler() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c24420015.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c24420015.cacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler():GetEquipTarget() and Duel.GetAttackTarget()~=nil
end
function c24420015.cafilter(c)
	return c:IsSetCard(0x244) and c:IsAbleToRemoveAsCost()
end
function c24420015.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c24420015.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and e:GetHandler():GetEquipTarget():IsChainAttackable(0,true) end
end
function c24420015.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec:IsRelateToBattle() then return end
	Duel.ChainAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
	ec:RegisterEffect(e1)
end
function c24420015.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffect(24420015)==0 then
		c24420015[ep]=c24420015[ep]+1
		tc:RegisterFlagEffect(24420015,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c24420015.clear(e,tp,eg,ep,ev,re,r,rp)
	c24420015[0]=0
	c24420015[1]=0
end


