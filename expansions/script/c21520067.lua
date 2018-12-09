--玲珑法师-海棠
function c21520067.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c21520067.ffilter,2,true)
	--fusion material
--[[	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c21520067.fscon)
	e0:SetOperation(c21520067.fsop)
	c:RegisterEffect(e0)--]]
	--remove from deck,next standby phase add to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520067,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,21520067+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21520067.rhtg)
	e1:SetOperation(c21520067.rhop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520067,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,21520067+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c21520067.thtg)
	e2:SetOperation(c21520067.thop)
	c:RegisterEffect(e2)
	--random effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetCondition(c21520067.condition)
	e4:SetOperation(c21520067.operation)
	c:RegisterEffect(e4)
end
function c21520067.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x3495) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
--[[
function c21520067.ffilter(c,fc)
	return c:IsFusionSetCard(0x3495) and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc)
end
function c21520067.fscon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(c21520067.ffilter,nil,e:GetHandler())
	if gc then
		mg:AddCard(gc)
		return c21520067.ffilter(gc,e:GetHandler()) and mg:GetClassCount(Card.GetCode)>=2
	end
	local fs=false
	if mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return mg:GetClassCount(Card.GetCode)>=2 and (fs or chkf==PLAYER_NONE)
end
function c21520067.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local sg=eg:Filter(c21520067.ffilter,gc,e:GetHandler())
	if gc then
		sg:Remove(Card.IsCode,nil,gc:GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	sg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end--]]
function c21520067.rmfilter(c,loc,tp)
	return c:IsAbleToRemove() and c:IsSetCard(0x495) and Duel.IsExistingMatchingCard(c21520067.ormfilter,tp,loc,0,1,nil,c:GetCode())
end
function c21520067.ormfilter(c,code)
	return c:IsAbleToRemove() and c:IsSetCard(0x495) and not c:IsCode(code)
end
function c21520067.thfilter(c,loc,tp)
	return c:IsAbleToHand() and c:IsSetCard(0x495) and Duel.IsExistingMatchingCard(c21520067.othfilter,tp,loc,0,1,nil,c:GetCode())
end
function c21520067.othfilter(c,code)
	return c:IsAbleToHand() and c:IsSetCard(0x495) and not c:IsCode(code)
end
function c21520067.rhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520067.rmfilter,tp,LOCATION_DECK,0,1,nil,LOCATION_DECK,e:GetHandlerPlayer()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_DECK)
end
function c21520067.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520067.rmfilter,tp,LOCATION_DECK,0,nil,LOCATION_DECK,e:GetHandlerPlayer())
	if g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		local g2=Duel.SelectMatchingCard(tp,c21520067.ormfilter,tp,LOCATION_DECK,0,1,1,nil,sg:GetFirst():GetCode())
		sg:Merge(g2)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		local tc=sg:GetFirst()
		while tc do 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_REMOVED)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
			e1:SetCondition(c21520067.rthcon)
			e1:SetOperation(c21520067.rthop)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	end
end
function c21520067.rthcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21520067.rthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c21520067.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520067.thfilter,tp,LOCATION_DECK,0,1,nil,LOCATION_DECK,e:GetHandlerPlayer()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,2,tp,LOCATION_DECK)
end
function c21520067.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520067.thfilter,tp,LOCATION_DECK,0,nil,LOCATION_DECK,e:GetHandlerPlayer())
	if g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c21520067.othfilter,tp,LOCATION_DECK,0,1,1,nil,sg:GetFirst():GetCode())
		sg:Merge(g2)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c21520067.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0
end
function c21520067.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--	math.randomseed(tonumber(tostring(require("os").time()):reverse():sub(1,6))+c:GetFieldID())
--	local val=math.random(1,3)
	local val=Duel.SelectOption(c:GetControler(),aux.Stringid(21520067,2),aux.Stringid(21520067,3),aux.Stringid(21520067,4))
	if val==0 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	elseif val==1 then
		Duel.Damage(1-tp,600,REASON_EFFECT)
	elseif val==2 then
		Duel.Recover(tp,600,REASON_EFFECT)
	end
end
