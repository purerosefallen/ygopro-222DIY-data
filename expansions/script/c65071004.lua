--以爱与恨之名
function c65071004.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65071004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65071004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65071004.target)
	e1:SetOperation(c65071004.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c65071004.deecon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65071004.deetg)
	e2:SetOperation(c65071004.deeop)
	c:RegisterEffect(e2)
end
c65071004.toss_coin=true
function c65071004.deecon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function c65071004.deefil(c)
	return c:IsCode(65071153)
end

function c65071004.deetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsCode(65071153) end
	if chk==0 then return Duel.IsExistingTarget(c65071004.deefil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,c65071004.deefil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	local cg=tc:GetColumnGroup()
	cg:Merge(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,cg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1-tp,0,0)
end

function c65071004.deeop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local cg=tc:GetColumnGroup()
		cg:AddCard(tc)
		if cg:GetCount()>0 then
			local dam=Duel.Destroy(cg,REASON_EFFECT)
			dam=dam*500
			if dam>0 then
				Duel.Damage(1-tp,dam,REASON_EFFECT)
			end
		end
	end
end

function c65071004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65071004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65071153,0,0x4011,2500,2000,8,RACE_SPELLCASTER,ATTRIBUTE_LIGHT,POS_FACEUP,tp) then return end
	local token=Duel.CreateToken(tp,65071153)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		--cannot release
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e2)
	   local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(1)
		token:RegisterEffect(e3)
	end
	Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		e:GetHandler():CancelToGrave(true)
		Duel.Equip(tp,e:GetHandler(),token)
		local tc=e:GetHandler():GetEquipTarget()
		--Equip limit
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_EQUIP_LIMIT)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		e4:SetValue(1)
		c:RegisterEffect(e4)
		--give effect
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_EQUIP)
		e5:SetCode(EFFECT_ATTACK_ALL)
		e5:SetValue(1)
		c:RegisterEffect(e5)
		--destroy
		local e8=Effect.CreateEffect(c)
		e8:SetDescription(aux.Stringid(65071004,2))
		e8:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN)
		e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e8:SetCode(EVENT_BATTLE_START)
		e8:SetCondition(c65071004.descon)
		e8:SetTarget(c65071004.destg)
		e8:SetOperation(c65071004.desop)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e9:SetRange(LOCATION_SZONE)
		e9:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e9:SetReset(RESET_EVENT+0x1fe0000)
		e9:SetTarget(c65071004.eftg)
		e9:SetLabelObject(e8)
		c:RegisterEffect(e9)
end
function c65071004.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end
function c65071004.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c65071004.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if c==tc then tc=Duel.GetAttacker() end
	if not tc:IsRelateToBattle() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local res=Duel.TossCoin(tp,1)
	if res==1 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c65071004.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
